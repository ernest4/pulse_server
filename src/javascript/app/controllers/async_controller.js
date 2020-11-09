import { Controller } from "stimulus";
// import axios from "axios";

// TODO: intercept the submits of the form and make async
// TODO: capture response and paste it

export default class extends Controller {
  // static targets = ["target"];

  initialize = () => {};

  connect = () => {
    // debugger;
    console.log("async connected");
    console.log(this.element);
    this.element.addEventListener("submit", this.handleSubmit);
  };

  disconnect = () => {
    this.element.removeEventListener("submit", this.handleSubmit);
  };

  handleSubmit = event => {
    event.preventDefault();

    const form = event.target;

    // debugger
    // console.log(event);
    // console.log(event.target.value);

    // https://pqina.nl/blog/async-form-posts-with-a-couple-lines-of-vanilla-javascript/
  };

  // toggle = () => {
  //   this.targetTargets.forEach(toggleTarget => {
  //     const toggleClass = toggleTarget.attributes["data-toggle-class"].value;
  //     toggleTarget.classList.toggle(toggleClass);
  //   });
  // };

  // add = () => this.load();

  // load = async () => {
  //   try {
  //     const response = await axios.get(this.data.get("url"), {
  //       headers: { "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content },
  //     });

  //     if (response.data) this.itemTarget.insertAdjacentHTML("beforeend", response.data);
  //   } catch (error) {
  //     this.itemTarget.insertAdjacentHTML("beforeend", error);
  //   }
  // };
}

// TODO: paste in <div data-target="async.response"></div> ....
