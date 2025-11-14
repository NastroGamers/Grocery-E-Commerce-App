const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const validate = require('../middleware/validate');
const { authLimiter } = require('../middleware/rateLimiter');

// Import controller (to be created)
// const authController = require('../controllers/auth.controller');

// Validation rules
const registerValidation = [
  body('name').trim().notEmpty().withMessage('Name is required'),
  body('email').isEmail().withMessage('Please provide a valid email'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  validate
];

const loginValidation = [
  body('email').isEmail().withMessage('Please provide a valid email'),
  body('password').notEmpty().withMessage('Password is required'),
  validate
];

const otpValidation = [
  body('phone').isMobilePhone().withMessage('Please provide a valid phone number'),
  validate
];

// Routes
// router.post('/register', authLimiter, registerValidation, authController.register);
// router.post('/login', authLimiter, loginValidation, authController.login);
// router.post('/send-otp', authLimiter, otpValidation, authController.sendOTP);
// router.post('/verify-otp', authLimiter, authController.verifyOTP);
// router.post('/google-callback', authController.googleCallback);
// router.post('/refresh-token', authController.refreshToken);
// router.post('/forgot-password', authLimiter, authController.forgotPassword);
// router.post('/reset-password', authController.resetPassword);
// router.post('/logout', authController.logout);

// Placeholder routes
router.post('/register', authLimiter, registerValidation, (req, res) => {
  res.json({ status: 'success', message: 'Auth controller to be implemented' });
});

router.post('/login', authLimiter, loginValidation, (req, res) => {
  res.json({ status: 'success', message: 'Auth controller to be implemented' });
});

module.exports = router;
