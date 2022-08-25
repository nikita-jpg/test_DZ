const path = require('path');
const CopyPlugin = require("copy-webpack-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const HtmlMinimizerPlugin = require("html-minimizer-webpack-plugin");

module.exports = {
  mode: "production",
  entry: './index.js',
  output: {
    path: path.resolve("", 'docs'),
    filename: 'bundle.js',
    clean: true
  },
  module: {
    rules: [{
      test: /\.css/,
      loader: 'import-glob-loader'
    }]
  },
  optimization: {
  },
  plugins: [
    new CopyPlugin({
    patterns: [
      { from: "./index.html", to: "" },
      { from: "./*.css", to: "" },
      { from: "./assets", to: "./assets" }
    ],
  }),
    new CssMinimizerPlugin({
        test: /\.css$/i,
      }),
    new HtmlMinimizerPlugin({
        test: /\.html$/i,
    }),
  ],
};