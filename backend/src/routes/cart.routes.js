const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.json({ status: 'success', message: 'cart routes - to be implemented' });
});

module.exports = router;
