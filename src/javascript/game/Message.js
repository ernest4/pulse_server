const MESSAGE_TYPE = {
  MOVE: 1,
  POSITION: 2,
  ENTER: 3,
  EXIT: 4,
  MAP_INIT: 5,
};

export const parse = data => {
  console.log("data");
  console.log(data);

  const view = new DataView(data);
  const messageType = view.getUint8(0, true);
  console.log(`message type: ${messageType}`);

  switch (messageType) {
    case 0: {
      // TODO:
      break;
    }
    case MESSAGE_TYPE.POSITION: {
      // [type,id,id,id,id,x,x,y,y]

      const playerId = view.getInt32(1, true);
      const x = view.getUint16(5, true);
      const y = view.getUint16(7, true);

      console.log("playerId");
      console.log(playerId);
      console.log("x");
      console.log(x);
      console.log("y");
      console.log(y);

      return { playerId, x, y };
    }
    case MESSAGE_TYPE.ENTER: {
      // [type,id,id,id,id,name,name,name,...]

      const playerId = view.getInt32(1, true);

      console.log("decoder utf-8");

      const decoder = new TextDecoder("utf-8");
      const textSlice = data.slice(5, data.length);
      const name = decoder.decode(textSlice);

      console.log(name);

      return { playerId, name };
    }
    case MESSAGE_TYPE.EXIT: {
      console.log("exit");
      break;
    }
    case MESSAGE_TYPE.MAP_INIT: {
      // [type,tileSize,width,width,height,height,tile,tile,tile,...]
      console.log("map init");

      const tileSize = view.getUint16(1, true);
      const width = view.getUint16(3, true);
      const height = view.getUint16(5, true);

      // couuuuld extract the tiles into plain array but...
      // const tiles = [];
      // for (let tile = 0; tile < width * height; tile++) {
      //   tiles.push(view.getUint16(5 + tile * 2, true));
      // }
      // might be more efficient to keep the tile info in the buffer where we can take advantage of
      // cache locality !!! lets try go with that...
      const tiles = data.slice(7, width * height);

      return { tileSize, width, height, tiles };
    }
    default: {
      console.log("Unrecognised message type received");
      return { error: "Unrecognised message type received" };
    }
  }
};

export const generate = () => {
  let t;

  return {};
};
