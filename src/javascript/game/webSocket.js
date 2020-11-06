import store from "./store";
import * as gameActions from "./store/actions/game";

const initWebSocket = () => {
  const ws = new WebSocket(wsUrl());

  ws.onopen = even => {
    // debugLog("onopen");
    // console.log(even);
    // log(`readyState: ${ws.readyState}`);

    // ws.send(Date.now()); // testing transmitting date to server
    store.dispatch(gameActions.setSocketOpen(true));
    // store.dispatch(gameActions.setSocketReadyState(ws.readyState));
  };

  ws.onclose = even => {
    // debugLog("onclose");
    // console.log(even);
    // log(`readyState: ${ws.readyState}`);
    store.dispatch(gameActions.setSocketOpen(false));
    // store.dispatch(gameActions.setSocketReadyState(ws.readyState));
  };

  ws.onmessage = event => {
    // debugLog(`onmessage`);
    // console.log(event);
    // debugLog(`readyState: ${ws.readyState}`);

    store.dispatch(gameActions.addServerMessageToQueue(event.data));
  };

  // return ws;
  // keep player socket globally accessible
  store.dispatch(gameActions.setSocket(ws));
};

export default initWebSocket;

const wsUrl = () =>
  process.env.NODE_ENV === "production" ? "wss://pulsemmo.herokuapp.com" : "ws://localhost:3001";
