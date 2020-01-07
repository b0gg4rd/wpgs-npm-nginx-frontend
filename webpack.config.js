const path = require('path');

module.exports = {
  entry: './src/index.ecs',
  mode: 'production',
  output: {
    filename: 'index.js',
    path: path.resolve(__dirname, 'dist')
  }
};

