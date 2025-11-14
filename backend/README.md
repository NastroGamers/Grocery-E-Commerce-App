# Grocery E-Commerce Backend API

Production-ready Node.js/Express backend for the Grocery E-Commerce Platform.

## Features

- ✅ **Authentication & Authorization**: JWT-based auth with refresh tokens, Google OAuth
- ✅ **User Management**: Customer, Admin, Vendor, Delivery Personnel roles
- ✅ **Product Catalog**: Categories, products, variants, inventory management
- ✅ **Shopping Cart & Wishlist**: Real-time cart management
- ✅ **Order Management**: Complete order lifecycle with status tracking
- ✅ **Payment Integration**: Razorpay, Stripe, QR code payments
- ✅ **Real-time Features**: WebSocket for order tracking, live chat
- ✅ **Delivery Management**: GPS tracking, delivery personnel assignment
- ✅ **Loyalty Program**: Points, tiers, rewards
- ✅ **Recommendations**: AI-powered product recommendations
- ✅ **Notifications**: Firebase Cloud Messaging, WhatsApp integration
- ✅ **Admin Dashboard**: Analytics, user management, inventory
- ✅ **Security**: Rate limiting, input validation, CORS, helmet
- ✅ **File Upload**: Cloudinary integration for images
- ✅ **Logging**: Winston logger with file rotation
- ✅ **Error Handling**: Centralized error handling

## Tech Stack

- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose ODM
- **Authentication**: JWT, bcrypt
- **Real-time**: Socket.IO
- **Payment**: Razorpay, Stripe
- **Cloud Storage**: Cloudinary
- **Notifications**: Firebase Admin SDK, Twilio
- **Email**: Nodemailer
- **Caching**: Redis
- **Logging**: Winston

## Installation

```bash
# Install dependencies
npm install

# Copy environment variables
cp .env.example .env

# Configure .env with your credentials

# Start development server
npm run dev

# Start production server
npm start
```

## Environment Variables

See `.env.example` for required environment variables.

## API Endpoints

### Authentication
- POST `/api/v1/auth/register` - Register new user
- POST `/api/v1/auth/login` - Login user
- POST `/api/v1/auth/send-otp` - Send OTP
- POST `/api/v1/auth/verify-otp` - Verify OTP
- POST `/api/v1/auth/google-callback` - Google OAuth
- POST `/api/v1/auth/refresh-token` - Refresh access token
- POST `/api/v1/auth/logout` - Logout user

### Products
- GET `/api/v1/products` - Get all products (with filters)
- GET `/api/v1/products/:id` - Get product by ID
- POST `/api/v1/products` - Create product (admin)
- PUT `/api/v1/products/:id` - Update product (admin)
- DELETE `/api/v1/products/:id` - Delete product (admin)

### Orders
- POST `/api/v1/orders` - Create order
- GET `/api/v1/orders` - Get user orders
- GET `/api/v1/orders/:id` - Get order details
- PUT `/api/v1/orders/:id/cancel` - Cancel order
- GET `/api/v1/orders/:id/track` - Track order (WebSocket)

### Payments
- POST `/api/v1/payments/create` - Create payment
- POST `/api/v1/payments/verify` - Verify payment
- POST `/api/v1/payments/qr/generate` - Generate QR code
- POST `/api/v1/payments/webhook` - Payment webhooks

### Admin
- GET `/api/v1/admin/dashboard` - Dashboard analytics
- GET `/api/v1/admin/users` - Manage users
- GET `/api/v1/admin/orders` - Manage orders
- PUT `/api/v1/admin/inventory` - Update inventory

[See full API documentation for complete endpoint list]

## Project Structure

```
backend/
├── src/
│   ├── models/          # Mongoose models
│   ├── controllers/     # Request handlers
│   ├── routes/          # API routes
│   ├── middleware/      # Custom middleware
│   ├── services/        # Business logic
│   ├── sockets/         # WebSocket handlers
│   ├── config/          # Configuration files
│   ├── utils/           # Utility functions
│   ├── app.js           # Express app setup
│   └── server.js        # Server entry point
├── logs/                # Log files
├── .env.example         # Environment variables template
├── package.json         # Dependencies
└── README.md            # This file
```

## Development

```bash
# Run in development mode with hot reload
npm run dev

# Run tests
npm test

# Lint code
npm run lint

# Format code
npm run format
```

## Production Deployment

```bash
# Build and run with Docker
docker-compose up -d

# Or deploy to cloud platform
# (AWS, GCP, Azure, Heroku, etc.)
```

## Security

- JWT-based authentication
- Password hashing with bcrypt
- Input validation and sanitization
- Rate limiting
- CORS protection
- Helmet security headers
- MongoDB injection prevention

## Performance

- Response compression
- Database indexing
- Redis caching
- Query optimization
- Connection pooling

## Monitoring

- Winston logging
- Error tracking
- Performance metrics
- Health check endpoint

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## License

MIT License

## Support

For support, email support@freshcart.com
