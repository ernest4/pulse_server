import React, { useState } from "react";

import Phaser from "phaser";
import Example from "./scenes/Example";

import { GAME_HEIGHT, GAME_WIDTH } from "./config";
import initWebSocket from "./webSocket";

class Game extends React.Component {
  componentDidMount() {
    const config = {
      type: Phaser.WEBGL,
      width: GAME_WIDTH,
      height: GAME_HEIGHT,
      parent: "phaser-game",
      scale: {
        mode: Phaser.Scale.WIDTH_CONTROLS_HEIGHT,
        // autoCenter: Phaser.Scale.CENTER_BOTH,
      },
      scene: [Example],
    };

    new Phaser.Game(config);

    initWebSocket();
  }

  shouldComponentUpdate() {
    return false;
  }

  render() {
    return <div id="phaser-game" />;
  }
}

export default Game;