const webpack = require("webpack");
const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");

module.exports = env => {
  const environment = env.development ? "development" : "production";

  return {
    devtool: "source-map",
    entry: ["react-hot-loader/patch", "./src/javascript/game/index.tsx"],
    output: {
      path: path.resolve(__dirname, "public", "game"),
      publicPath: env.production ? "/game/" : "/",
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
    resolve: {
      extensions: [".js", ".jsx", ".tsx", ".ts"],
      alias: { "react-dom": "@hot-loader/react-dom" },
    },
    devServer: { contentBase: "./dist", historyApiFallback: true, port: 3001 },
    plugins: [
      new CleanWebpackPlugin(),
      new webpack.DefinePlugin({ "process.env": { NODE_ENV: JSON.stringify(environment) } }),
      new HtmlWebpackPlugin({
        template: path.resolve(__dirname, "src/javascript/game/index.html"),
      }),
      new MiniCssExtractPlugin({
        filename: "css/[name].[contenthash].css",
        chunkFilename: "css/[id].[contenthash].chunk.css",
      }),
    ],
  };
};
