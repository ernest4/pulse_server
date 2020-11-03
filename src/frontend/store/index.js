import { createStore } from "redux";
import gameReducer from "./reducers/game";

export default createStore(gameReducer);
