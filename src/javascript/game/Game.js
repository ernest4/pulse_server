import React from "react";
import Phaser from "phaser";
import Main from "./scenes/Main";
import { GAME_HEIGHT, GAME_WIDTH } from "./config";
import Network from "./scenes/Network";

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
      physics: { default: "arcade", arcade: { debug: false, gravity: { y: 0 } } },
      scene: [
        Network, // Network is last to process change so it can send packets to server (might need to tweak the order later)
        Main,
        // UI ? ... got react handling UI for now
      ],
    };

    new Phaser.Game(config);
  }

  shouldComponentUpdate() {
    return false;
  }

  render() {
    return <div id="phaser-game" />;
  }
}

export default Game;
