import Phaser, { Scene } from "phaser";
import store from "../store";
import * as gameActions from "../store/actions/game";
import { log, debugLog } from "../debug/logging";
import createColorRectangle from "../debug/rectangles";
import initEntity from "../entity";
import initCameraControls from "../camera";

// TODO: add optional full screen support https://rexrainbow.github.io/phaser3-rex-notes/docs/site/fullscreen/

export default class Main extends Scene {
  constructor() {
    super({ key: "Main", active: true }); // active: true, to launch on start up
    this.tileScale = 100; // TODO: whats this again??
  }

  preload() {
    // debugger
    // this.load.image("turtle", "assets/images/turtle_T.jpg");
    // this.load.image("shark", "assets/images/shark_T.png");
    // this.load.image("grass", "assets/images/grass_T.png");
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

    // const { tiles } = this.cache.json.get("testy");
    // const { tiles } = this.cache.json.get("testy2");
    // console.log(tiles); // testing level loading

    // const tileMap = new TileMap();

    // createColorRectangle({ scene: this, x: 50, y: 50, width: 100, height: 100, color: "green" });

    // tiles.forEach((row, y) => {
    //   row.forEach((column, x) => {
    //     const entity = initEntity({ scene: this, x, y, key: column });
    //   });
    // });

    // ws.close();
    // It may be helpful to examine the socket's bufferedAmount attribute before attempting to close
    // the connection to determine if any data has yet to be transmitted on the network. If this
    // value isn't 0, there's pending data still, so you may wish to wait before closing the
    // connection.

    // TODO: the prototype.

    // Then can start building out rudimentary level with camera movement and left click
    // turn based movement using redux to manage game state.

    // MAP target size 50x50, 100x50 and 100 x 100 = 10,000 tiles. 4 leves of height (no height for now)?

    // Finally look at storing game map on server, reading it, updateing based on client movement
    // and persisiting it in the file (later, in DB).

    // Then look at adding basic graphics, something basic enough to show public but get the style
    // accross (chibi xcom, androidarts etc) and emphasize on engine vision to be cheap, simple but
    // serve ludicrous number of users!

    // light testing
    // this.add.sprite(600, 400, "bump_map_test").setPipeline("Light2D");
    // const light = this.lights.addLight(600, 400, 800).setIntensity(2);
    // this.lights.enable().setAmbientColor(0x888888);

    // this.add
    //   .sprite(600, 400, "bump_map_test_pixel")
    //   .setDisplaySize(100, 100)
    //   .setPipeline("Light2D");
    // const light = this.lights.addLight(600, 400, 800, 0x00ff00).setIntensity(1);
    // this.lights.enable().setAmbientColor(0x000000);

    // this.input.on("pointermove", pointer => {
    //   light.x = pointer.x;
    //   light.y = pointer.y;
    // });

    // TODO: init controls for character. Camera will be locket to character
    // initCameraControls(this);
  }

  // TODO: send character position to server if there is new position, once every 20th of a second
  // at most.
  update(time, deltaTime) {}

  render() {
    // this.cameras.main.debug.cameraInfo(this.game.camera, 32, 32);
  }

  updateMain(parent, key, data) {
    // serverMessages
    switch (key) {
      case "serverMessages":
        // TODO: check if map message present (TODO: need to include message types in parsedMessage !!!)
        // TODO: build the map
        // TODO: remove map message from queue or let the Network scene flush the queue?
        // this.generateTiles();
        console.log(data);
        break;
    }
  }
}

// const checkSocketHealth = ({ socket, deltaTime }) => {
//   // log(`socketOpen: ${gameState.socketOpen}`);
//   log(`socketOpen: ${socket.socketReadState}`);
// };

// const applyServerMessageQueueToGameState = gameState => {
//   const messages = gameState.serverMessageQueue;

//   messages.forEach(message => {
//     // TODO: ... apply the message to produce draft game state
//   });

//   // TODO: ...implement
//   // const newGameState = updateGameState(currentGameState, messages);
//   // updateGameState(currentGameState, messages);

//   return gameState;
// };

// const transitionGameState = ({ currentGameState, newGameState, scene }) => {
//   // TODO: ... implement. This needs too perform all the animations, tweens, smooth transitions from
//   // current game state to new game state.
//   let _keep;

//   return newGameState; // just a mock for now...instant transition
// };

// const broadcastClientMessageQueueToServer = ({ socket, messages }) => {
//   const validClientMessages = validateClientMessages(messages);
//   // store.dispatch(gameActions.setClientMessageQueue([])); // flush client messages

//   // broadcast validClientMessages.....
//   //

//   validClientMessages.forEach(message => {
//     socket.send(message);
//   });
// };

// const validateClientMessages = messages => {
//   let _keep;
//   // TODO: implement

//   return messages;
// };

// const yieldTiles = ({ tiles, callback }) =>
//   tiles.forEach((row, x) => row.forEach((column, y) => callback({ x, y, column })));

// listening to redux ??
// might not be efficient. Could have many async state changes in 16ms which would fire the
// listener. The listener would then have to walk through the entire state to figure out where
// the change is and compute the next change for each and every small change.
// Just use the update() loop. There you walk through the whole state once very 16ms fixed rate!

// let currentValue;
// function handleChange() {
//   const previousValue = currentValue;
//   currentValue = store.getState().activeTile[0];

//   console.log("store activity");
//   console.log(store.getState());
//   console.log("prev val");
//   console.log(previousValue);
//   console.log("cur val");
//   console.log(currentValue);

//   if (previousValue !== currentValue) {
//     console.log("Some deep nested property changed from", previousValue, "to", currentValue);
//     store.dispatch(gameActions.setActiveTile([1, 1]));
//   }
// }

// const unsubscribe = store.subscribe(handleChange);
// // // unsubscribe()
