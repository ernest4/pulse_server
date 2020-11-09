import { Controller } from "stimulus";
import axios from "axios";

// TODO: intercept the submits of the form and make async
// TODO: capture response and paste it

export default class extends Controller {
  static targets = ["response"];

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

  handleSubmit = async event => {
    try {
      event.preventDefault();

      const form = event.target;

      // https://pqina.nl/blog/async-form-posts-with-a-couple-lines-of-vanilla-javascript/

      // TESTING
      console.log(form.method);
      // console.log(new FormData(form)); // This wont work...

      // TESTING
      // const object = {};
      // (new FormData(form)).forEach((value, key) => (object[key] = value));
      // const json = JSON.stringify(object);
      // console.log(json);

      const response = await axios({
        url: form.action,
        method: form.method,
        headers: {
          "X-CSRF-Token": document.querySelector("input[name=authenticity_token]").value,
        },
        [form.method === "get" ? "params" : "data"]: new FormData(form),
      });

      console.log(response);
      console.log(response.data);
      this.insertResponse(form, response.data);
    } catch (e) {
      console.log(e);
      // form.insertAdjacentHTML("beforeend", error);
      this.insertResponse(form, error);
    }
  };

  // private

  insertResponse = (form, data) => {
    this.clearResponse();

    if (data?.template) {
      return form.insertAdjacentHTML("beforeend", this.responseWrapper(data.template));
    }

    if (data?.message) {
      return form.insertAdjacentHTML("beforeend", this.responseWrapper(data.message));
    }

    form.insertAdjacentHTML("beforeend", this.responseWrapper("unknown server response"));
  };

  clearResponse = () => {
    this.responseTargets.forEach(responseTarget => {
      responseTarget.parentNode.removeChild(responseTarget);
    });
  };

  responseWrapper = template => {
    return `<div data-target="async.response">${template}</div>`;
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
  //       headers: { "X-CSRF-Token": document.querySelector("meta[name=authenticity_token]").content },
  //     });

  //     if (response.data) this.itemTarget.insertAdjacentHTML("beforeend", response.data);
  //   } catch (error) {
  //     this.itemTarget.insertAdjacentHTML("beforeend", error);
  //   }
  // };
}

// TODO: paste in <div data-target="async.response"></div> ....
