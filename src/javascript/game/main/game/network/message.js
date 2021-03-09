export const MESSAGE_TYPE = {
  MOVE: 1,
  POSITION: 2,
  ENTER: 3,
  EXIT: 4,
  MAP_INIT: 5,
  // TODO: use this potentially more optimal way to batch initialize all characters
  // CHARACTERS_INIT: 6, // kinda like ENTER + POSITION but for all present characters
};

export const parse = data => {
  console.warn("New message: raw data");
  console.log(data);

  const view = new DataView(data);
  const messageType = view.getUint8(0, true);
  console.log(`New message: message type: ${messageType}`);

  switch (messageType) {
    case 0: {
      // TODO:
      break;
    }
    case MESSAGE_TYPE.POSITION: {
      // [type,id,id,id,id,x,x,y,y]

      const characterId = view.getInt32(1, true);
      const x = view.getUint16(5, true);
      const y = view.getUint16(7, true);

      console.log("characterId");
      console.log(characterId);
      console.log("x");
      console.log(x);
      console.log("y");
      console.log(y);

      return { messageType, characterId, x, y };
    }
    case MESSAGE_TYPE.ENTER: {
      // [type,id,id,id,id,name,name,name,...]

      const characterId = view.getInt32(1, true);

      console.log("decoder utf-8");

      const decoder = new TextDecoder("utf-8");
      const textSlice = data.slice(5, data.length);
      const name = decoder.decode(textSlice);

      console.log(name);

      // TODO: add the image / texture info for character appearance (send key)
      return { messageType, characterId, name };
    }
    case MESSAGE_TYPE.EXIT: {
      console.log("exit");
      const characterId = view.getInt32(1, true);

      return { messageType, characterId };
    }
    // TODO: use this potentially more optimal way to batch initialize all characters
    // case MESSAGE_TYPE.CHARACTERS_INIT: {
    //   console.log("CHARACTERS_INIT");
    //   const characters = [];

    //   characters.push({ characterId, name });

    //   return { messageType, characters };
    // }
    case MESSAGE_TYPE.MAP_INIT: {
      // [type,tileSize,width,width,height,height,tile,tile,tile,...]
      console.log("map init");

      // TODO: some automatic way to track and return byte offset?? maybe if this was a class and we
      // had a method for each get... that would track it's own byte count and post that to class...
      const tileSize = view.getUint8(1, true);
      const mapWidth = view.getUint16(2, true);
      const mapHeight = view.getUint16(4, true);

      // couuuuld extract the tiles into plain array but...
      // const tiles = [];
      // for (let tile = 0; tile < width * height; tile++) {
      //   tiles.push(view.getUint16(5 + tile * 2, true));
      // }
      // might be more efficient to keep the tile info in the buffer where we can take advantage of
      // cache locality !!! lets try go with that...
      const tile_bytes = 2;
      const tiles_array_buffer = data.slice(6, mapWidth * mapHeight * tile_bytes); // raw ArrayBuffer
      const tiles = new Int16Array(tiles_array_buffer); // can loop over Int16Array with forEach()

      console.log("tileSize");
      console.log(tileSize);
      console.log("mapWidth");
      console.log(mapWidth);
      console.log("mapHeight");
      console.log(mapHeight);
      console.log("tiles");
      console.log(tiles);

      return { messageType, tileSize, mapWidth, mapHeight, tiles };
    }
    default: {
      console.log("Unrecognised message type received");
      return { error: "Unrecognised message type received" };
    }
  }
};

export const serialize = message => {
  switch (message.messageType) {
    case MESSAGE_TYPE.MOVE: {
      console.log("move");

      const buffer = new ArrayBuffer(2);
      const view = new DataView(buffer);

      view.setUint8(0, MESSAGE_TYPE.MOVE, true);
      view.setUint8(1, message.direction, true);

      console.warn("move buffer");
      console.log(buffer);

      return buffer;
    }
    default: {
      console.log("Unrecognised message type received");
      return { error: "Unrecognised message type received" };
    }
  }
};
// let player_id = null;

// const MESSAGE_TYPE = {
//   MOVE: 1,
//   POSITION: 2,
//   ENTER: 3,
//   EXIT: 4,
//   MAP_INIT: 5,
// }

// const ws = new WebSocket(location.origin.replace('http', 'ws'));
// ws.binaryType = 'arraybuffer';
// ws.onmessage = msg => {
//   console.warn(msg);

//   console.log('msg.data');
//   console.log(msg.data);

//   const view = new DataView(msg.data);
//   const message_type = view.getUint8(0, true)
//   console.log(`message type: ${message_type}`);

//   switch(message_type) {
//     case 0:
//       // TODO:
//       break;
//     case MESSAGE_TYPE.POSITION:
//       const x = view.getUint16(1, true);
//       const y = view.getUint16(3, true);
//       console.log('x');
//       console.log(x);
//       console.log('y');
//       console.log(y);
//       break;
//     case MESSAGE_TYPE.ENTER:
//       // TODO:

//       // normal client will have its own id after log in and other players will be pushed into array...
//       player_id = view.getInt32(1, true);

//       console.log('decoder utf-8');

//       const decoder = new TextDecoder("utf-8");
//       const textSlice = msg.data.slice(5 , msg.data.length);
//       console.log(decoder.decode(textSlice));
//       break;
//     case MESSAGE_TYPE.EXIT:
//       console.log('exit');
//       break;
//     default:
//       console.log('Unrecognised message type received');
//   }
// };

// const sendEnterTest = () => {
//   const encoder = new TextEncoder("utf-8");
//   const encoded = encoder.encode("Γεια σουκόσμ");

//   const buffer = new ArrayBuffer(1 + encoded.length);
//   const view = new DataView(buffer);

//   encoded.forEach((byte, index) => view.setUint8(index + 1, byte));

//   view.setUint8(0, MESSAGE_TYPE.ENTER, true);
//   // view.setUint16(2, 500, true);
//   console.log('buffer');
//   console.log(buffer);

//   ws.send(buffer);
// };

// // const sendEnterButton = document.getElementById('send_enter_button');
// // sendEnterButton.addEventListener('click', sendEnterTest);

// const sendMove = ({direction}) => {
//   const buffer = new ArrayBuffer(2);
//   const view = new DataView(buffer);

//   view.setUint8(0, MESSAGE_TYPE.MOVE, true);
//   view.setUint8(1, direction, true);

//   console.warn('move buffer');
//   console.log(buffer);

//   ws.send(buffer);
// };

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

// document.addEventListener('keydown', keyDownHandler, false);
