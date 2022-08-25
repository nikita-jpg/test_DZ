const path = require('path');
const CopyPlugin = require("copy-webpack-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const HtmlMinimizerPlugin = require("html-minimizer-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlCriticalWebpackPlugin = require("html-critical-webpack-plugin");

const DIST_PATH = path.resolve(__dirname, "docs");

module.exports = {
  mode: "production",
  entry: './index.js',
  output: {
    path: path.resolve("", 'docs'),
    filename: 'bundle.js',
    clean: true
  },
  module: {
    rules: [
      {
        test: /\.css$/i,
        use: [MiniCssExtractPlugin.loader, "css-loader"],
      },
    ]
  },
  optimization: {
  },
  plugins: [
    new CopyPlugin({
      patterns: [
        { from: "./index.html", to: "" },
        // { from: "./*.css", to: "" },
        // { from: "./assets", to: "./assets" }
      ],
    }),
    new MiniCssExtractPlugin(),
    new CssMinimizerPlugin({
      test: /\.css$/i,
    }),
    new HtmlCriticalWebpackPlugin({
      base: DIST_PATH,
      src: "index.html",
      dest: "index.html",
      inline: true,
      minify: true,
      extract: true,
      width: 1200,
      height: 800,
      penthouse: {
        blockJSRequests: false,
      },
    }),
    new HtmlMinimizerPlugin({
      test: /\.html$/i,
    }),
  ],
};