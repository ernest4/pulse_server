import { createAction } from "redux-actions";

export const setSocket = createAction("SET_SOCKET");
export const setSocketOpen = createAction("SET_SOCKET_OPEN");

export const addServerMessageToQueue = createAction("ADD_SERVER_MESSAGE_TO_QUEUE");
export const setServerMessageToQueue = createAction("SET_SERVER_MESSAGE_TO_QUEUE");
export const addClientMessageToQueue = createAction("ADD_CLIENT_MESSAGE_TO_QUEUE");
export const setClientMessageToQueue = createAction("SET_CLIENT_MESSAGE_TO_QUEUE");

export const showUI = createAction("SHOW_UI");

export const setActiveTile = createAction("SET_ACTIVE_TILE");
export const setTargetTile = createAction("SET_TARGET_TILE");
