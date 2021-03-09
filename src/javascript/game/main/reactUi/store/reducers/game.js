import { handleActions } from "redux-actions";
import reduceReducers from "reduce-reducers";
import produce from "immer";

const initialSocketState = {
  socket: null,
  socketOpen: false,
};

const initialMessagesState = {
  serverMessageQueue: [],
  clientMessageQueue: [],
};

const initialUiState = {
  showUi: false,
};

const initialGameState = {
  activeTile: null,
  targetTile: null,
};

const socketReducer = handleActions(
  {
    SET_SOCKET: produce((state, action) => {
      state.socket = action.payload;
    }),
    SET_SOCKET_OPEN: produce((state, action) => {
      state.socketOpen = action.payload;
    }),
  },
  initialSocketState
);

const messagesReducer = handleActions(
  {
    ADD_SERVER_MESSAGE_TO_QUEUE: produce((state, action) => {
      state.serverMessageQueue.push(action.payload);
    }),
    SET_SERVER_MESSAGE_TO_QUEUE: produce((state, action) => {
      state.serverMessageQueue = action.payload;
    }),
    ADD_CLIENT_MESSAGE_TO_QUEUE: produce((state, action) => {
      state.clientMessageQueue.push(action.payload);
    }),
    SET_CLIENT_MESSAGE_TO_QUEUE: produce((state, action) => {
      state.clientMessageQueue = action.payload;
    }),
  },
  initialMessagesState
);

const uiReducer = handleActions(
  {
    SHOW_UI: produce((state, action) => {
      state.showUi = action.payload;
    }),
  },
  initialUiState
);

const gameReducer = handleActions(
  {
    SET_ACTIVE_TILE: produce((state, action) => {
      console.log("active tile");
      console.log(action.payload); // TESTING
      state.activeTile = action.payload;
    }),
    SET_TARGET_TILE: produce((state, action) => {
      console.log("target tile");
      console.log(action.payload); // TESTING
      state.targetTile = action.payload;
    }),
  },
  initialGameState
);

export default reduceReducers(socketReducer, messagesReducer, uiReducer, gameReducer);
