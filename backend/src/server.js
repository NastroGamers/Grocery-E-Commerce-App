const app = require('./app');
const mongoose = require('mongoose');
const http = require('http');
const socketIO = require('socket.io');
const logger = require('./utils/logger');
const { initializeSocketIO } = require('./sockets');

// Load environment variables
require('dotenv').config();

const PORT = process.env.PORT || 5000;
const MONGODB_URI = process.env.NODE_ENV === 'production'
  ? process.env.MONGODB_URI_PROD
  : process.env.MONGODB_URI;

// Create HTTP server
const server = http.createServer(app);

// Initialize Socket.IO
const io = socketIO(server, {
  cors: {
    origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
    methods: ['GET', 'POST'],
    credentials: true
  },
  pingTimeout: 60000,
  pingInterval: 25000
});

// Initialize Socket.IO handlers
initializeSocketIO(io);

// Make io accessible to routes
app.set('io', io);

// Database connection with retry logic
const connectDB = async (retries = 5) => {
  try {
    await mongoose.connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 5000,
    });

    logger.info('MongoDB connected successfully');

    // Handle connection events
    mongoose.connection.on('error', (err) => {
      logger.error('MongoDB connection error:', err);
    });

    mongoose.connection.on('disconnected', () => {
      logger.warn('MongoDB disconnected');
    });

    mongoose.connection.on('reconnected', () => {
      logger.info('MongoDB reconnected');
    });

  } catch (error) {
    logger.error(`MongoDB connection error: ${error.message}`);

    if (retries > 0) {
      logger.info(`Retrying connection... (${retries} attempts left)`);
      setTimeout(() => connectDB(retries - 1), 5000);
    } else {
      logger.error('Failed to connect to MongoDB after multiple attempts');
      process.exit(1);
    }
  }
};

// Start server
const startServer = async () => {
  try {
    // Connect to database
    await connectDB();

    // Start listening
    server.listen(PORT, () => {
      logger.info(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
      logger.info(`API Version: ${process.env.API_VERSION}`);
    });
  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
};

// Handle unhandled promise rejections
process.on('unhandledRejection', (err) => {
  logger.error('Unhandled Promise Rejection:', err);
  // Close server & exit process
  server.close(() => process.exit(1));
});

// Handle uncaught exceptions
process.on('uncaughtException', (err) => {
  logger.error('Uncaught Exception:', err);
  process.exit(1);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    logger.info('HTTP server closed');
    mongoose.connection.close(false, () => {
      logger.info('MongoDB connection closed');
      process.exit(0);
    });
  });
});

// Start the server
startServer();

module.exports = { server, io };
