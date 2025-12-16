const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// In-memory storage for visitor count
let visitorCount = 0;

// Routes
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/api/visitors', (req, res) => {
  res.json({ 
    count: visitorCount,
    message: 'Current visitor count'
  });
});

app.post('/api/visitors/increment', (req, res) => {
  visitorCount++;
  res.json({ 
    count: visitorCount,
    message: 'Visitor count incremented'
  });
});

app.post('/api/visitors/reset', (req, res) => {
  visitorCount = 0;
  res.json({ 
    count: visitorCount,
    message: 'Visitor count reset'
  });
});

// Start server
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`Backend server running on port ${PORT}`);
});

// Export for testing
module.exports = { app, server };
