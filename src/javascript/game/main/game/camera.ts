import { Scene } from "phaser";

const initCameraControls = (scene: Scene) => {
  const scrollSpeed = 100;

  scene.input.keyboard.on("keydown_UP", (e: any) => {
    // TODO: need access to delta time, maybe set flag here and act on it in update?
    // console.log(e);
    scene.cameras.main.y += scrollSpeed;

    // this.cameras.main.pan(500, 500, 2000, "Power2"); // messing around with pan and zoom
    // this.cameras.main.zoomTo(4, 3000);
  });

  scene.input.keyboard.on("keydown_DOWN", (e: any) => {
    scene.cameras.main.y -= scrollSpeed;
  });

  scene.input.keyboard.on("keydown_LEFT", (e: any) => {
    scene.cameras.main.x += scrollSpeed;
  });

  scene.input.keyboard.on("keydown_RIGHT", (e: any) => {
    scene.cameras.main.x -= scrollSpeed;
  });
};

export default initCameraControls;