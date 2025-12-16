const request = require('supertest');
const { app, server } = require('./server');

describe('Backend API Tests', () => {
  
  afterAll((done) => {
    server.close(done);
  });

  test('GET /health - should return healthy status', async () => {
    const response = await request(app).get('/health');
    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe('healthy');
    expect(response.body).toHaveProperty('timestamp');
  });

  test('GET /api/visitors - should return visitor count', async () => {
    const response = await request(app).get('/api/visitors');
    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('count');
    expect(response.body).toHaveProperty('message');
  });

  test('POST /api/visitors/increment - should increment count', async () => {
    const before = await request(app).get('/api/visitors');
    const initialCount = before.body.count;
    
    const response = await request(app).post('/api/visitors/increment');
    expect(response.statusCode).toBe(200);
    expect(response.body.count).toBe(initialCount + 1);
  });

  test('POST /api/visitors/reset - should reset count to 0', async () => {
    await request(app).post('/api/visitors/increment');
    
    const response = await request(app).post('/api/visitors/reset');
    expect(response.statusCode).toBe(200);
    expect(response.body.count).toBe(0);
  });
});
