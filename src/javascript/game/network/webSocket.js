import { serialize, parse } from "./message";

const initWebSocket = scene => {
  const ws = new WebSocket(wsUrl());
  ws.binaryType = "arraybuffer";

  ws.onopen = event => scene.registry.set("socketOpen", { isOpen: true, event });

  ws.onclose = event => scene.registry.set("socketOpen", { isOpen: false, event });

  ws.onmessage = event => {
    const parsedMessage = parse(event.data);
    pushMessageToPhaserRegistry(scene, parsedMessage);
  };

  ws.serializeAndSend = message => ws.send(serialize(message));

  return ws; // also return it ?? not sure if useful ??
};

export default initWebSocket;

const wsUrl = () => window.location.origin.replace("http", "ws");
const pushMessageToPhaserRegistry = (scene, parsedMessage) => {
  if (!scene.registry.serverMessages) scene.registry.set("serverMessages", []);

  scene.registry.values.serverMessages.push(parsedMessage);
};
