const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function(app) {
  // This proxy configuration is only used in development mode
  app.use(
    '/api',
    createProxyMiddleware({
      target: 'http://localhost:5000',
      changeOrigin: true,
      pathRewrite: {
        '^/api': '/api'
      },
      onProxyReq: (proxyReq, req, res) => {
        console.log('Proxying request to:', proxyReq.path);
      }
    })
  );
}; 