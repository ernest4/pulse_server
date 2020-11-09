import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["target"];

  initialize = () => {};

  connect = () => {};

  disconnect = () => {};

  toggle = () => {
    this.targetTargets.forEach(toggleTarget => {
      const toggleClass = toggleTarget.attributes["data-toggle-class"].value;
      toggleTarget.classList.toggle(toggleClass);
    });
  };
}
