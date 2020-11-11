import { generate, parse } from "./Message";
import store from "./store";
import * as gameActions from "./store/actions/game";

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

    const parsedMessage = parse(event.data);

    // ....
    // push to phaser master game state thingy that other phaser things will listen on !?!?!

    // TODO: probably might need to push to phaser state mechanisms directly here (as well as redux
    // for UI...updates)
    store.dispatch(gameActions.addServerMessageToQueue(parsedMessage));
  };

  ws.serializeAndSend = message => {
    const serializedMessage = generate(message);
    ws.send(serializedMessage);
  };

  // keep player socket globally accessible
  store.dispatch(gameActions.setSocket(ws));
  return ws; // also return it ?? not sure if useful ??
};

export default initWebSocket;

const wsUrl = () => window.location.origin.replace("http", "ws");
