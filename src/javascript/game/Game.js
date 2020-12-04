import React from "react";
import Phaser from "phaser";
import Main from "./scenes/Main";
import { GAME_HEIGHT, GAME_WIDTH } from "./config";
import Network from "./scenes/Network";
import UI from "./scenes/UI";

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
        Main,
        UI, // UI should (almost) always be first to process inputs
        Network, // Network is last to process change
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
