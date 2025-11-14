const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/auth');

router.get('/profile', protect, (req, res) => {
  res.json({ status: 'success', message: 'User routes - to be implemented' });
});

module.exports = router;
