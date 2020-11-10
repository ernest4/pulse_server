import store from "./store";
import * as gameActions from "./store/actions/game";

const MESSAGE_TYPE = {
  MOVE: 1,
  POSITION: 2,
  ENTER: 3,
  EXIT: 4,
  MAP_INIT: 5,
};

const initWebSocket = () => {
  const ws = new WebSocket(wsUrl());
  ws.binaryType = "arraybuffer";

  ws.onopen = even => {
    console.log("onopen");
    console.log(even);
    // log(`readyState: ${ws.readyState}`);

    // ws.send(Date.now()); // testing transmitting date to server
    store.dispatch(gameActions.setSocketOpen(true));
    // store.dispatch(gameActions.setSocketReadyState(ws.readyState));
  };

  ws.onclose = even => {
    console.log("onclose");
    console.log(even);
    // log(`readyState: ${ws.readyState}`);
    store.dispatch(gameActions.setSocketOpen(false));
    // store.dispatch(gameActions.setSocketReadyState(ws.readyState));
  };

  ws.onmessage = event => {
    console.log(`onmessage`);
    console.log(event);
    // debugLog(`readyState: ${ws.readyState}`);

    // TODO: process message here

    // ....
    // push to phaser master game state thingy !?!?!

    // TODO: probably might need to push to phaser state mechanisms directly here (as well as redux
    // for UI...updates)
    store.dispatch(gameActions.addServerMessageToQueue(event.data));
  };

  // return ws;
  // keep player socket globally accessible
  store.dispatch(gameActions.setSocket(ws));
};

export default initWebSocket;

const wsUrl = () => window.location.origin.replace("http", "ws");
