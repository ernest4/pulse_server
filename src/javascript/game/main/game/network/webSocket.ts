import { Scene } from "phaser";
import { serialize, parse } from "./message";

const initWebSocket = (scene: Scene) => {
  const ws = new WebSocket(wsUrl());
  ws.binaryType = "arraybuffer";

  ws.onopen = event => scene.registry.set("socketOpen", { isOpen: true, event });

  ws.onclose = event => scene.registry.set("socketOpen", { isOpen: false, event });

  ws.onmessage = event => {
    const parsedMessage = parse(event.data);
    pushMessageToPhaserRegistry(scene, parsedMessage);
  };

  // @ts-ignore
  ws.serializeAndSend = (message: any) => ws.send(serialize(message));

  return ws; // also return it ?? not sure if useful ??
};

export default initWebSocket;

const wsUrl = () => window.location.origin.replace("http", "ws");

const pushMessageToPhaserRegistry = (scene: Scene, parsedMessage: any) => {
  if (!scene.registry.values.serverMessages) scene.registry.set("serverMessages", []);

  scene.registry.values.serverMessages = [...scene.registry.values.serverMessages, parsedMessage];
};
