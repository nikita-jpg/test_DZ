const path = require('path');
const CopyPlugin = require("copy-webpack-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const HtmlMinimizerPlugin = require("html-minimizer-webpack-plugin");

module.exports = {
  mode: "production",
  entry: './src/index.js',
  output: {
    path: path.resolve("", 'dist'),
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
    // minimize: true,
    // minimizer: [
    //   new CssMinimizerPlugin({
    //     test: /\.css$/i,
    //   }),
    // ],
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