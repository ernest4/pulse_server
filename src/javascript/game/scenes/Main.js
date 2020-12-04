import Phaser, { Scene } from "phaser";
import store from "../store";
import * as gameActions from "../store/actions/game";
// import { log, debugLog } from "../debug/logging";
// import createColorRectangle from "../debug/rectangles";
// import initEntity from "../entity";
// import initCameraControls from "../camera";
import { MESSAGE_TYPE } from "../network/message";

// TODO: add optional full screen support https://rexrainbow.github.io/phaser3-rex-notes/docs/site/fullscreen/

export default class Main extends Scene {
  constructor() {
    super({ key: "Main", active: true }); // active: true, to launch on start up
  }

  preload() {
    this.load.image("turtle", "images/turtle_T.jpg");
    this.load.image("shark", "images/shark_T.png");
    this.load.image("grass", "images/grass_T.png");
    this.load.image("item", "images/item_T.png");
    this.load.image("unit", "images/unit_T.png");
    // // this.load.json("testy", "assets/areas/testy.json");
    // this.load.json("testy2", "assets/areas/testy2.json");
    // // this.load.image("sky", "assets/sky.png");
    // // this.load.image("ground", "assets/platform.png");
    // // this.load.image("star", "assets/star.png");
    // // this.load.image("bomb", "assets/bomb.png");
    // // this.load.spritesheet("dude", "assets/dude.png", { frameWidth: 32, frameHeight: 48 });
    // this.load.image("bump_map_test", [
    //   "assets/images/shark_T.png",
    //   "assets/images/bump_map_example.png",
    // ]);
    // this.load.image("bump_map_test_pixel", [
    //   "assets/images/shark_T.png",
    //   "assets/images/bump_map_example_pixel.png",
    // ]);
  }

  create() {
    this.registry.events.on("changedata", this.updateMain, this);

    this.input.mouse.disableContextMenu(); // disable default right click

    const text = this.add.text(25, 500, "Toggle UI", {
      backgroundColor: "white",
      color: "blue",
      fontSize: 48,
    });
    text.setInteractive({ useHandCursor: true });
    text.on("pointerup", () => {
      store.dispatch(gameActions.showUI(!store.getState().showUi));
    });

    // this.input.on("pointermove", pointer => {
    //   light.x = pointer.x;
    //   light.y = pointer.y;
    // });
    // TODO: init controls for character. Camera will be locket to character
    // initCameraControls(this);

    this.initControls();

    this.scene.launch("Network");
  }

  // TODO: send character position to server if there is new position, once every 20th of a second
  // at most.
  update(time, deltaTime) {}

  render() {
    // this.cameras.main.debug.cameraInfo(this.game.camera, 32, 32);
  }

  updateMain(parent, key, data) {
    console.log("Main update"); // TESTING

    switch (key) {
      case "serverMessages":
        // console.log(data);
        this.processServerMessages(data);
        break;
      case "characters":
        this.processCharacters(data);
        break;
      default:
      // blank...
    }
  }

  processServerMessages(messages) {
    if (!messages?.length) return;

    messages.forEach((message, index) => {
      switch (message.messageType) {
        case MESSAGE_TYPE.MAP_INIT:
          // TODO: remove map message from queue or let the Network scene flush the queue?
          this.mapInit(message);
          break;
        case MESSAGE_TYPE.ENTER:
          this.characterInit(message);
          break;
        case MESSAGE_TYPE.POSITION:
          this.positionUpdate(message);
          break;
        default:
        // TODO: ...
      }
    });

    this.registry.values.serverMessages = []; // flush the buffer
  }

  mapInit({ tiles, tileSize, mapHeight, mapWidth }) {
    // TODO: build the map
    // createColorRectangle({ scene: this, x: 50, y: 50, width: 100, height: 100, color: "green" });
    // tiles.forEach((row, y) => {
    //   row.forEach((column, x) => {
    //     const entity = initEntity({ scene: this, x, y, key: column });
    //   });
    // });

    // TODO: maybe put this logic into some TileMap class??
    tiles?.forEach((tile, index) => {
      const x = (index % mapWidth) * tileSize;
      const y = Math.floor(index / mapWidth) * tileSize;

      this.createTile({ tile, x, y, tileSize });
    });
  }

  createTile({ tile, x, y, tileSize }) {
    // TODO: use some stuff from here for now...
    // const entity = initEntity({ scene: this, x, y, key: column });

    const keys = ["grass", "turtle", "item", "shark"];

    const entity = this.add
      .image(x, y, keys[tile - 1])
      .setOrigin(0)
      .setDisplaySize(tileSize, tileSize);

    // TESTING
    entity.setInteractive();
    entity.on("pointerdown", pointer => {
      console.log(`tile: ${tile}`);
      entity.setTint(0xff0000);
    });
    entity.on("pointerout", pointer => {
      entity.clearTint();
    });
    entity.on("pointerup", pointer => {
      entity.clearTint();
    });
  }

  characterInit({ characterId, name }) {
    const character = { characterId, name };

    this.pushCharacterToPhaserRegistry(character);
  }

  pushCharacterToPhaserRegistry(character) {
    if (!this.registry.values.characters) this.registry.set("characters", {});

    this.registry.values.characters = {
      ...this.registry.values.characters,
      // TODO: normally image key will come with the message, for now just dropping it in manually
      [character.characterId]: { ...character, image: "unit" },
    };
  }

  positionUpdate({ characterId, x, y }) {
    const character = this.registry.values.characters[characterId];
    this.registry.values.characters[characterId] = { ...character, x, y };
  }

  processCharacters(characters) {
    if (!characters?.length) return;

    Object.values(characters).forEach(({ x, y, image }) => {
      if (isNaN(x) || isNaN(y) || !image) return; // dont add to scene until position and texture info ready

      // TODO: this isnt printing
      console.error("character rendered !!!");

      const entity = this.add.image(x, y, image).setOrigin(0).setDisplaySize(32, 32);
    });
  }

  initControls() {
    this.input.keyboard.on("keydown-A", event => {
      console.log("Hello from the A Key!");
      this.sendMoveMessage({ direction: 1 });
    });

    this.input.keyboard.on("keydown-W", event => {
      console.log("Hello from the W Key!");
      this.sendMoveMessage({ direction: 3 });
    });

    this.input.keyboard.on("keydown-D", event => {
      console.log("Hello from the D Key!");
      this.sendMoveMessage({ direction: 5 });
    });

    this.input.keyboard.on("keydown-S", event => {
      console.log("Hello from the S Key!");
      this.sendMoveMessage({ direction: 7 });
    });

    // const keyDownHandler = (event) => {
    //   switch(event.keyCode){
    //     case 37: // left
    //     case 65: // a
    //       sendMove({direction: 1});
    //       break;
    //     case 38: // up
    //     case 87: // w
    //       sendMove({direction: 3});
    //       break;
    //     case 39: // right
    //     case 68: // d
    //       sendMove({direction: 5});
    //       break;
    //     case 40: // down
    //     case 83: // s
    //       sendMove({direction: 7});
    //       break;
    //     default:
    //       console.log('unrecognised key command');
    //   }
    // }
  }

  sendMoveMessage(data) {
    const message = { messageType: MESSAGE_TYPE.MOVE, ...data };

    this.pushClientMessageToPhaserRegistry(message);
  }

  pushClientMessageToPhaserRegistry(message) {
    if (!this.registry.values.clientMessages) this.registry.set("clientMessages", []);

    this.registry.values.clientMessages = [...this.registry.values.clientMessages, message];
  }
}
