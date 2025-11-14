const logger = require('../utils/logger');

const initializeSocketIO = (io) => {
  // Connection handling
  io.on('connection', (socket) => {
    logger.info(`Client connected: ${socket.id}`);

    // Join user room
    socket.on('join', (userId) => {
      socket.join(`user:${userId}`);
      logger.info(`User ${userId} joined their room`);
    });

    // Join order tracking room
    socket.on('track_order', (orderId) => {
      socket.join(`order:${orderId}`);
      logger.info(`Tracking order: ${orderId}`);
    });

    // Join delivery tracking room
    socket.on('track_delivery', (deliveryId) => {
      socket.join(`delivery:${deliveryId}`);
      logger.info(`Tracking delivery: ${deliveryId}`);
    });

    // Support chat
    socket.on('join_support', ({ userId, ticketId }) => {
      socket.join(`support:${ticketId}`);
      logger.info(`User ${userId} joined support chat for ticket ${ticketId}`);
    });

    socket.on('support_message', ({ ticketId, message }) => {
      io.to(`support:${ticketId}`).emit('new_message', message);
    });

    // Delivery personnel location update
    socket.on('update_location', ({ deliveryId, location }) => {
      io.to(`delivery:${deliveryId}`).emit('location_updated', location);
    });

    // Disconnect handling
    socket.on('disconnect', () => {
      logger.info(`Client disconnected: ${socket.id}`);
    });

    // Error handling
    socket.on('error', (error) => {
      logger.error(`Socket error: ${error.message}`);
    });
  });

  logger.info('Socket.IO initialized');
};

module.exports = { initializeSocketIO };
