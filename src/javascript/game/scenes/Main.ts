import { Scene } from "phaser";
import store from "../store";
import * as gameActions from "../store/actions/game";
// import { log, debugLog } from "../debug/logging";
// import createColorRectangle from "../debug/rectangles";
// import initEntity from "../entity";
// import initCameraControls from "../camera";
import { MESSAGE_TYPE } from "../network/message";

// TODO: add optional full screen support https://rexrainbow.github.io/phaser3-rex-notes/docs/site/fullscreen/

class Main extends Scene {
  constructor() {
    super({ key: "Main", active: true }); // active: true, to launch on start up
  }

  preload() {
    this.load.image("water", "images/water_T.png");
    this.load.image("block", "images/block_T.png");
    this.load.image("grass", "images/grass_T.png");
    this.load.image("item", "images/item_T.png");
    this.load.image("unit", "images/unit_T.png");
    // // this.load.json("testy", "assets/areas/testy.json");
    // this.load.json("testy2", "assets/areas/testy2.json");
    // // this.load.image("sky", "assets/sky.png");
    // // this.load.image("ground", "assets/platform.png");
    // // this.load.image("star", "assets/star.png");
    // // this.load.image("bomb", "assets/bomb.png");
    // // this.load.spritesheet("dude", "assets/dude.png", { frameWidth: 32, frameHeight: 48 });
    // this.load.image("bump_map_test", [
    //   "assets/images/block_T.png",
    //   "assets/images/bump_map_example.png",
    // ]);
    // this.load.image("bump_map_test_pixel", [
    //   "assets/images/block_T.png",
    //   "assets/images/bump_map_example_pixel.png",
    // ]);
  }

  create() {
    this.registry.events.on("changedata", this.updateMain, this);

    this.input.mouse.disableContextMenu(); // disable default right click

    const text = this.add.text(25, 500, "Toggle UI", {
      backgroundColor: "white",
      color: "blue",
      fontSize: 48,
    });
    text.setInteractive({ useHandCursor: true });
    text.on("pointerup", () => {
      store.dispatch(gameActions.showUI(!store.getState().showUi));
    });

    // this.input.on("pointermove", pointer => {
    //   light.x = pointer.x;
    //   light.y = pointer.y;
    // });
    // TODO: init controls for character. Camera will be locket to character
    // initCameraControls(this);

    this.initControls();

    this.scene.launch("Network");
  }

  // TODO: send character position to server if there is new position, once every 20th of a second
  // at most.
  update(_time: number, _deltaTime: number) {
    const e = this.events;
  }

  render(): void {
    // this.cameras.main.debug.cameraInfo(this.game.camera, 32, 32);
  }

  updateMain(_parent: any, key: any, data: any) {
    console.log("Main update"); // TESTING

    switch (key) {
      case "serverMessages":
        // console.log(data);
        this.processServerMessages(data);
        break;
      case "characters":
        console.error("Characters update"); // TESTING
        console.error(data);
        this.processCharacters(data);
        break;
      default:
      // blank...
    }
  }

  processServerMessages(messages: any[]) {
    if (!messages?.length) return;

    messages.forEach(
      (
        message: {
          messageType?: any;
          tiles?: any;
          tileSize?: any;
          mapHeight?: any;
          mapWidth?: any;
          characterId?: any;
          name?: any;
          x?: any;
          y?: any;
        },
        _index: any
      ) => {
        switch (message.messageType) {
          case MESSAGE_TYPE.MAP_INIT:
            this.mapInit(message);
            break;
          // TODO: use this potentially more optimal way to batch initialize all characters
          // case MESSAGE_TYPE.CHARACTERS_INIT:
          //   this.charactersInit(message);
          //   break;
          case MESSAGE_TYPE.ENTER:
            this.characterInit(message);
            break;
          case MESSAGE_TYPE.POSITION:
            this.positionUpdate(message);
            break;
          case MESSAGE_TYPE.EXIT:
            this.characterExit(message);
            break;
          default:
          // TODO: ...
        }
      }
    );

    this.registry.values.serverMessages = []; // flush the buffer
  }

  mapInit({ tiles, tileSize, mapHeight, mapWidth }: any) {
    // TODO: build the map
    // createColorRectangle({ scene: this, x: 50, y: 50, width: 100, height: 100, color: "green" });
    // tiles.forEach((row, y) => {
    //   row.forEach((column, x) => {
    //     const entity = initEntity({ scene: this, x, y, key: column });
    //   });
    // });

    // TODO: maybe put this logic into some TileMap class??
    tiles?.forEach((tile: any, index: number) => {
      const x = (index % mapWidth) * tileSize;
      const y = Math.floor(index / mapWidth) * tileSize;

      this.createTile({ tile, x, y, tileSize });
    });
  }

  createTile({ tile, x, y, tileSize }: any) {
    // TODO: use some stuff from here for now...
    // const entity = initEntity({ scene: this, x, y, key: column });

    const keys = ["grass", "water", "item", "block"];

    const entity = this.add
      .image(x, y, keys[tile - 1])
      .setOrigin(0)
      .setDisplaySize(tileSize, tileSize);

    // TESTING
    entity.setInteractive();
    entity.on("pointerdown", (_pointer: any) => {
      console.log(`tile: ${tile}`);
      entity.setTint(0xff0000);
    });
    entity.on("pointerout", (_pointer: any) => {
      entity.clearTint();
    });
    entity.on("pointerup", (_pointer: any) => {
      entity.clearTint();
    });
  }

  // TODO: use this potentially more optimal way to batch initialize all characters
  // charactersInit({ characters }) {
  //   // TODO: probably more efficient way to do this...
  //   characters.each(character => {
  //     this.pushCharacterToPhaserRegistry(character);
  //   });
  // }

  characterInit({ characterId, name }: any) {
    const character = { characterId, name };

    this.pushCharacterToPhaserRegistry(character);
  }

  pushCharacterToPhaserRegistry(character: { characterId: any; name?: any }) {
    if (!this.registry.values.characters) this.registry.set("characters", {});

    this.registry.values.characters = {
      ...this.registry.values.characters,
      // TODO: normally image key will come with the message, for now just dropping it in manually
      [character.characterId]: { ...character, image: "unit" },
    };
  }

  positionUpdate({ characterId, x, y }: any) {
    const { characters } = this.registry.values;
    // const character = characters[characterId];
    // this.registry.values.characters[characterId] = { ...character, x, y };
    this.registry.values.characters = {
      ...characters,
      [characterId]: { ...characters[characterId], x, y },
    };
  }

  characterExit({ characterId }: any) {
    const character = this.registry.values.characters[characterId];

    // TODO: might not need to spread existing character attributes again??
    this.registry.values.characters = {
      ...this.registry.values.characters,
      [characterId]: { ...character, exiting: true },
    };
  }

  processCharacters(characters: { [s: string]: unknown } | ArrayLike<unknown>) {
    const characters_array = Object.values(characters);
    if (!characters_array?.length) return;

    characters_array.forEach(
      ({ characterId, x, y, image, name, phaserContainer, exiting }: any) => {
        if (isNaN(x) || isNaN(y) || !image) return; // dont add to scene until position and texture info ready

        // console.warn("character rendered !!!"); // TESTING

        if (!phaserContainer) {
          phaserContainer = this.add.container(x, y);

          // initialize character entity
          // const entity = this.add.image(x, y, image).setOrigin(0).setDisplaySize(32, 32);
          const entity = this.add.image(0, 0, image).setOrigin(0).setDisplaySize(32, 32);
          phaserContainer.add(entity);
          // This update will set value but wont replace the characters array, thus wont trigger the
          // registry callback for characters (which is what we want as we're just adding meta data).
          const characterName = this.add.text(0, -12, name);
          // characterName.font = "Arial";
          characterName.setOrigin(0, 0.5);
          phaserContainer.add(characterName);

          this.registry.values.characters[characterId].phaserContainer = phaserContainer;
        } else if (exiting) {
          phaserContainer.destroy(); // destroy container, recursively calls destroy on children too..
          // update the registry. This wont trigger registry callback
          delete this.registry.values.characters[characterId];
        } else {
          // move character entity. This wont trigger registry callback
          phaserContainer.setPosition(x, y);
        }
      }
    );
  }

  initControls() {
    this.input.keyboard.on("keydown-A", (_event: any) => {
      console.log("Hello from the A Key!");
      this.sendMoveMessage({ direction: 1 });
    });

    this.input.keyboard.on("keydown-W", (_event: any) => {
      console.log("Hello from the W Key!");
      this.sendMoveMessage({ direction: 3 });
    });

    this.input.keyboard.on("keydown-D", (_event: any) => {
      console.log("Hello from the D Key!");
      this.sendMoveMessage({ direction: 5 });
    });

    this.input.keyboard.on("keydown-S", (_event: any) => {
      console.log("Hello from the S Key!");
      this.sendMoveMessage({ direction: 7 });
    });

    // const keyDownHandler = (event) => {
    //   switch(event.keyCode){
    //     case 37: // left
    //     case 65: // a
    //       sendMove({direction: 1});
    //       break;
    //     case 38: // up
    //     case 87: // w
    //       sendMove({direction: 3});
    //       break;
    //     case 39: // right
    //     case 68: // d
    //       sendMove({direction: 5});
    //       break;
    //     case 40: // down
    //     case 83: // s
    //       sendMove({direction: 7});
    //       break;
    //     default:
    //       console.log('unrecognised key command');
    //   }
    // }
  }

  sendMoveMessage(data: { direction: number }) {
    const message = { messageType: MESSAGE_TYPE.MOVE, ...data };

    this.pushClientMessageToPhaserRegistry(message);
  }

  pushClientMessageToPhaserRegistry(message: any) {
    if (!this.registry.values.clientMessages) this.registry.set("clientMessages", []);

    this.registry.values.clientMessages = [...this.registry.values.clientMessages, message];
  }
}

export default Main;
