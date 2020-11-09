import "../css/main.css";
import "core-js/stable";
import "regenerator-runtime/runtime";

// TODO: ... load stimulus...

// COPY PASTA FROM RAILS BELOW

// /* eslint no-console:0 */
// // This file is automatically compiled by Webpack, along with any other files
// // present in this directory. You're encouraged to place your actual application logic in
// // a relevant structure within app/javascript and only use these pack files to reference
// // that code so it'll be compiled.
// //
// // To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// // layout file, like app/views/layouts/application.html.erb

// // Uncomment to copy all static images under ../images to the output folder and reference
// // them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// // or the `imagePath` JavaScript helper below.
// //
// // const images = require.context('../images', true)
// // const imagePath = (name) => images(name, true)

// import '../css/application.css'
// import intersectionObserver from "intersection-observer";
import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";
// import "tippy.js/dist/tippy.css";
// import "tippy.js/themes/light.css";
// import "motion"

// // NOTE: Very dirty hack to expose axios to total global scope of the app (so it can be used in
// // script tag in app/components/input/group_component.rb)
// import axios from "axios";
// window.axios = axios;

const application = Application.start();
const context = require.context("./controllers", true, /\.js$/);
application.load(definitionsFromContext(context));

// document.addEventListener("turbolinks:before-cache", () => {
//   application.controllers.forEach(({ teardown }) =>
//     typeof teardown === "function" ? teardown() : ""
//   );
// });

// // Support component names relative to this directory:
// const componentRequireContext = require.context("components", true);
// const ReactRailsUJS = require("react_ujs");

// ReactRailsUJS.useContext(componentRequireContext);

// // Need this for RJS errors:
// document.addEventListener("ajax:error", (xhr, status, error) => {
//   if (status) console.log(status.responseText);
//   return console.log(error);
// });
