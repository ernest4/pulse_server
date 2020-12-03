import Phaser, { Scene } from "phaser";
import store from "../store";
import * as gameActions from "../store/actions/game";
import { log, debugLog } from "../debug/logging";
import createColorRectangle from "../debug/rectangles";
import initEntity from "../entity";
import initCameraControls from "../camera";

// TODO: add optional full screen support https://rexrainbow.github.io/phaser3-rex-notes/docs/site/fullscreen/

export default class UI extends Scene {
  constructor() {
    super({ key: "UI", active: true }); // active: true, to launch on start up
    // this.tileScale = 100; // TODO: whats this again??
  }

  preload() {}

  create() {
    this.registry.events.on("changedata", this.updateUI, this);
    this.input.mouse.disableContextMenu(); // disable default right click
  }

  // TODO: send character position to server if there is new position, once every 20th of a second
  // at most.
  update(time, deltaTime) {}

  render() {
    // this.cameras.main.debug.cameraInfo(this.game.camera, 32, 32);
  }

  updateUI() {}
}
