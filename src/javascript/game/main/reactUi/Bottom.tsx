import React from "react";
import { useSelector, useDispatch } from "react-redux";

import * as gameActions from "./store/actions/game";

const Bottom = () => {
  const dispatch = useDispatch();

  return (
    <div>
      <div
        style={{
          position: "absolute",
          width: "100wv",
          height: 100,
          bottom: 0,
          backgroundColor: "#fcfcfc",
        }}
      >
        <button type="button" onClick={() => dispatch(gameActions.showUI(false))}>
          close
        </button>
      </div>
    </div>
  );
};

export default Bottom;
