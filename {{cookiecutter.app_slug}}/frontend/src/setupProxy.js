const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function(app) {
  // This proxy configuration is only used in development mode
  app.use(
    '/api',
    createProxyMiddleware({
      target: process.env.REACT_APP_API_URL || 'http://localhost:5000',
      changeOrigin: true,
      pathRewrite: {
        '^/api': '/api'
      }
    })
  );
}; 