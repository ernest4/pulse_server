import React, { useState, useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";

import * as gameActions from "./store/actions/game";

import { GAME_HEIGHT, GAME_WIDTH } from "./config";

const LEFT_UI_WIDTH = 50;

const calculateLeftOffset = () => window.innerWidth / 2 - GAME_WIDTH / 2;

const UI = () => {
  // const showUi = useSelector(state => state.showUi);

  return (
    <div className="fixed">
      <div className="pt-8">Testy</div>
      <Left />
      <Top />
      <Bottom />
    </div>
  );
};

export default UI;

const Left = () => {
  const [leftOffset, setLeftOffset] = useState(calculateLeftOffset());
  const handleResize = () => setLeftOffset(calculateLeftOffset);

  useEffect(() => {
    window.addEventListener("resize", handleResize);
    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, []);

  return (
    <div
      style={{
        position: "absolute",
        left: leftOffset,
        width: LEFT_UI_WIDTH,
        height: GAME_HEIGHT,
        backgroundColor: "yellow",
        opacity: 0.5,
      }}
    />
  );
};

const Top = () => (
  <div
    style={{
      position: "absolute",
      width: GAME_WIDTH,
      height: 20,
      top: 0,
      backgroundColor: "#fcfcfc",
    }}
  >
    Ad Finitum © / OutlierStudio: [year] / twitter / youtube / patreon / supporters ... \ version
  </div>
);

const Bottom = () => {
  const dispatch = useDispatch();

  return (
    <div>
      <div
        style={{
          position: "absolute",
          width: GAME_WIDTH,
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
