import { Scene } from "phaser";
import store from "../store";
import * as gameActions from "../store/actions/game";
import initWebSocket from "../network/webSocket";

const PACKETS_PER_SECOND = 20; // 20 MAX !!
const MIN_PACKET_INTERVAL = 1 / PACKETS_PER_SECOND;

export default class Network extends Scene {
  constructor() {
    super({ key: "Network", active: true });
    this.lastPacketTime = 0;
  }

  create() {
    this.ws = initWebSocket(this);
    store.dispatch(gameActions.setSocket(this.ws)); // keep player socket globally accessible to UI?

    this.registry.events.on("changedata", this.updateRedux, this);
  }

  updateRedux(parent, key, data) {
    // TODO: update redux
    console.log("parent");
    console.log(parent);
    console.log("key");
    console.log(key);
    console.log("data");
    console.log(data);

    // 1:
    // TODO: probably might need to push to phaser state mechanisms directly here (as well as redux
    // for UI...updates)
    // store.dispatch(gameActions.addServerMessageToQueue(parsedMessage));

    // 2:
    // store.dispatch(gameActions.setSocketOpen(true));

    // 3:
    // store.dispatch(gameActions.setSocketOpen(false));
  }

  // TODO: send updates to server every 20th of a second at most.
  update(time, deltaTime) {
    this.lastPacketTime += deltaTime;

    if (this.lastPacketTime < MIN_PACKET_INTERVAL) return;

    this.lastPacketTime = 0;

    this.registry.values.clientMessages.forEach(clientMessage => {
      this.ws.serializeAndSend(clientMessage);
    });
  }

  // render() {}
}
