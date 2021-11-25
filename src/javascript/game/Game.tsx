import React, { Component } from "react";
import Phaser from "phaser";
import Main from "./game/scenes/Main";
import { GAME_HEIGHT, GAME_WIDTH } from "./game/config";
import Network from "./game/scenes/Network";
import PhaserUI from "./game/scenes/PhaserUI";

class Game extends Component {
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
        PhaserUI, // UI should (almost) always be first to process inputs
        Network, // Network is last to process change
      ],
    };

    // eslint-disable-next-line no-new
    new Phaser.Game(config);
  }

  shouldComponentUpdate() {
    return false;
  }

  render() {
    return <div id="phaser-game" className="fixed pt-8" />;
  }
}

export default Game;
