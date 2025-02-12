const request = require('supertest');
const express = require('express');
const { Pool } = require('pg');
const { app, startServer } = require('../server');

// Mock the pg Pool
jest.mock('pg', () => {
  const mPool = {
    query: jest.fn(),
    end: jest.fn(),
  };
  return { Pool: jest.fn(() => mPool) };
});

const pool = new Pool();
let server;

describe('Backend API Tests', () => {
  beforeAll(() => {
    server = startServer();
  });

  afterAll(done => {
    if (server) {
      server.close(done);
    } else {
      done();
    }
  });

  beforeEach(() => {
    // Clear all mocks before each test
    jest.clearAllMocks();
  });

  // Test 1: GET /api/data should return data when database has records
  test('GET /api/data returns data when records exist', async () => {
    const mockData = {
      rows: [
        { id: 1, key: 1, value: 100, created_at: "2025-02-03T23:26:45.709Z" },
        { id: 2, key: 2, value: 200, created_at: "2025-02-03T23:26:45.709Z" }
      ]
    };
    pool.query.mockResolvedValueOnce(mockData);

    const response = await request(app)
      .get('/api/data');

    expect(response.status).toBe(200);
    expect(response.body.data).toEqual(mockData.rows);
    expect(response.body.timestamp).toBeDefined();
  });

  // Test 2: GET /api/data should handle empty database
  test('GET /api/data handles empty database', async () => {
    pool.query.mockResolvedValueOnce({ rows: [] });

    const response = await request(app)
      .get('/api/data');

    expect(response.status).toBe(200);
    expect(response.body.message).toBe('No data found in database');
  });

  // Test 3: GET /api/data should handle database errors
  test('GET /api/data handles database errors', async () => {
    pool.query.mockRejectedValueOnce(new Error('Database error'));

    const response = await request(app)
      .get('/api/data');

    expect(response.status).toBe(500);
    expect(response.body.message).toBe('Error fetching data from database');
  });

  // Test 4: POST /api/init-db should initialize database successfully
  test('POST /api/init-db initializes database successfully', async () => {
    pool.query.mockResolvedValueOnce({}).mockResolvedValueOnce({});

    const response = await request(app)
      .post('/api/init-db');

    expect(response.status).toBe(200);
    expect(response.body.message).toBe('Database initialized successfully');
    expect(pool.query).toHaveBeenCalledTimes(2);
  });

  // Test 5: POST /api/init-db should handle database errors
  test('POST /api/init-db handles database errors', async () => {
    pool.query.mockRejectedValueOnce(new Error('Database error'));

    const response = await request(app)
      .post('/api/init-db');

    expect(response.status).toBe(500);
    expect(response.body.message).toBe('Error initializing database');
  });

  // Test 6: POST /api/clear-db should clear database successfully
  test('POST /api/clear-db clears database successfully', async () => {
    pool.query.mockResolvedValueOnce({});

    const response = await request(app)
      .post('/api/clear-db');

    expect(response.status).toBe(200);
    expect(response.body.message).toBe('Database cleared successfully');
    expect(pool.query).toHaveBeenCalledWith('DELETE FROM data');
  });

  // Test 7: POST /api/clear-db should handle database errors
  test('POST /api/clear-db handles database errors', async () => {
    pool.query.mockRejectedValueOnce(new Error('Database error'));

    const response = await request(app)
      .post('/api/clear-db');

    expect(response.status).toBe(500);
    expect(response.body.message).toBe('Error clearing database');
  });

  // Test 8: Verify CORS headers
  test('API endpoints should have CORS headers', async () => {
    const response = await request(app)
      .get('/api/data')
      .set('Origin', 'http://localhost:3000');

    expect(response.headers['access-control-allow-origin']).toBe('http://localhost:3000');
    expect(response.headers['access-control-allow-credentials']).toBe('true');
  });

  // Test 9: Database connection error handling
  test('Database connection errors are handled gracefully', async () => {
    const originalPool = new Pool();
    originalPool.query.mockRejectedValueOnce(new Error('Connection refused'));

    const response = await request(app)
      .get('/api/data');

    expect(response.status).toBe(500);
    expect(response.body.error).toBeDefined();
  });

  // Test 10: Verify JSON parsing middleware
  test('API correctly parses JSON body', async () => {
    const testData = { test: 'data' };
    
    const response = await request(app)
      .post('/api/init-db')
      .send(testData)
      .set('Content-Type', 'application/json');

    expect(response.status).toBe(200);
  });
}); 