const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const TerserPlugin = require("terser-webpack-plugin");
const HtmlCriticalPlugin = require("html-critical-webpack-plugin");
const path = require("path");

const DIST_PATH = path.resolve(__dirname, "docs");

/**
 * @type {import("webpack").Configuration}
 */
const config = {
  mode: "production",
  devtool: "source-map",
  devServer: {
    static: {
      directory: DIST_PATH,
    },
    port: 3000,
  },
  entry: {
    script: path.resolve(__dirname, "src", "scripts.js"),
  },
  output: {
    path: DIST_PATH,
    filename: "[name].[contenthash].js",
    assetModuleFilename: "assets/[name][ext][query]",
    clean: true,
  },
  module: {
    rules: [
      {
        test: /.css$/,
        use: [MiniCssExtractPlugin.loader, "css-loader"],
      },
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        type: "asset",
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/i,
        type: "asset/resource",
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: path.resolve(__dirname, "src", "index.html"),
    }),
    new MiniCssExtractPlugin(),
    new HtmlCriticalPlugin({
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
  ],
  optimization: {
    chunkIds: "named",
    minimize: true,
    minimizer: [new CssMinimizerPlugin()],
  },
};

module.exports = config;