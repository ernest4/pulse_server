import { Scene } from "phaser";
import store from "../../reactUi/store";
import * as gameActions from "../../reactUi/store/actions/game";
import initWebSocket from "../network/webSocket";

const PACKETS_PER_SECOND = 20; // 20 MAX !!
const MIN_PACKET_INTERVAL = 1 / PACKETS_PER_SECOND;

export default class Network extends Scene {
  constructor() {
    super({ key: "Network" }); // turn this on when main game is initialized and listeners set up!
    this.lastPacketTime = 0;
  }

  create() {
    this.ws = initWebSocket(this);
    // TODO: dispatch init event to registry. Let the UI scene read and set redux there...
    // store.dispatch(gameActions.setSocket(this.ws)); // keep player socket globally accessible to UI?

    this.registry.events.on("changedata", this.updateTestLog, this);
  }

  // updateGame(parent, key, data) {
  //   this.updatePhaser(parent, key, data);
  //   this.updateRedux(parent, key, data);
  // }

  // updateGame(...params) {
  //   // this.updatePhaser(...params);
  //   this.updateRedux(...params);
  // }

  // updatePhaser(parent, key, data) {
  //   console.log("phaser update");
  // }

  // TODO: this should probably me moved to UI scene...
  // updateRedux(parent, key, data) {
  //   console.log("redux update");
  //   // TODO: update redux
  //   // console.log("parent");
  //   // console.log(parent);
  //   console.log("key");
  //   console.log(key);
  //   console.log("data");
  //   console.log(data);

  //   // 1:
  //   // TODO: probably might need to push to phaser state mechanisms directly here (as well as redux
  //   // for UI...updates)
  //   // store.dispatch(gameActions.addServerMessageToQueue(parsedMessage));

  //   // 2:
  //   // store.dispatch(gameActions.setSocketOpen(true));

  //   // 3:
  //   // store.dispatch(gameActions.setSocketOpen(false));
  // }

  updateTestLog(parent, key, data) {
    console.log("network update");
    // TODO: update redux
    // console.log("parent");
    // console.log(parent);
    console.log("key");
    console.log(key);
    console.log("data");
    console.log(data);
  }

  // TODO: send updates to server every 20th of a second at most.
  update(time, deltaTime) {
    this.lastPacketTime += deltaTime;

    if (this.lastPacketTime < MIN_PACKET_INTERVAL) return;

    this.lastPacketTime = 0;

    if (!this.registry.values.clientMessages?.length) return;

    this.registry.values.clientMessages.forEach(clientMessage => {
      this.ws.serializeAndSend(clientMessage);
    });

    this.registry.values.clientMessages = []; // flush the buffer
  }

  // render() {}
}
