import React, { useState, useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import { useTransition, animated } from "react-spring";

import * as gameActions from "./store/actions/game";

import { GAME_HEIGHT, GAME_WIDTH } from "./config";

const LEFT_UI_WIDTH = 50;

const calculateLeftOffset = () => window.innerWidth / 2 - GAME_WIDTH / 2;

const UI = () => {
  const dispatch = useDispatch();
  const [leftOffset, setLeftOffset] = useState(calculateLeftOffset());
  const showUi = useSelector(state => state.showUi);

  const handleResize = () => setLeftOffset(calculateLeftOffset);

  useEffect(() => {
    window.addEventListener("resize", handleResize);
    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, []);

  const transitions = useTransition(showUi, null, {
    from: { marginBottom: -100 },
    enter: { marginBottom: 0 },
    leave: { marginBottom: -100 },
  });

  return (
    <div>
      <div className="pt-8">Testy</div>
      {/* Left */}
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
      {/* Top */}
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
      {/* Bottom */}
      <div>
        {transitions.map(
          ({ item, key, props }) =>
            item && (
              <animated.div
                key={key}
                style={{
                  ...props,
                  position: "absolute",
                  width: GAME_WIDTH,
                  height: 100,
                  bottom: 0,
                  backgroundColor: "#fcfcfc",
                }}
              >
                <div onClick={() => dispatch(gameActions.showUI(false))}>close</div>
              </animated.div>
            )
        )}
      </div>
    </div>
  );
};

export default UI;
