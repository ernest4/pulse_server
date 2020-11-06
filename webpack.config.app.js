const webpack = require("webpack");
const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");

module.exports = env => {
  const environment = env.development ? "development" : "production";

  return {
    devtool: "source-map",
    entry: "./src/javascript/app/index.js",
    output: {
      path: path.resolve(__dirname, "public", "app"),
      publicPath: env.production ? "/app/" : "/",
      filename: env.production ? "js/[name].[contenthash].js" : "js/bundle.js",
      chunkFilename: env.production ? "js/[name].[contenthash].chunk.js" : "js/[name].chunk.js",
    },
    module: {
      rules: [
        { test: /\.(js|jsx)$/, use: "babel-loader", exclude: /node_modules/ },
        {
          test: /\.css$/,
          use: [
            MiniCssExtractPlugin.loader,
            { loader: "css-loader", options: { importLoaders: 1 } },
            "postcss-loader",
          ],
        },
        { test: /\.ts(x)?$/, loader: "ts-loader", exclude: /node_modules/ },
      ],
    },
    plugins: [
      new CleanWebpackPlugin(),
      new webpack.DefinePlugin({ "process.env": { NODE_ENV: JSON.stringify(environment) } }),
      new MiniCssExtractPlugin({
        filename: "css/[name].[contenthash].css",
        chunkFilename: "css/[id].[contenthash].chunk.css",
      }),
    ],
  };
};
