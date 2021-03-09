import Phaser from "phaser";

const COLOR = {
  green: 0x00ff00,
  blue: 0x0000ff,
  red: 0xff0000,
  yellow: 0xffff00,
  cyan: 0x00ffff,
  purple: 0xff00ff,
};

// createColorRectangle
const createColorRectangle = ({ scene, x, y, width, height, color }: any) => {
  const rect = new Phaser.Geom.Rectangle(x, y, width, height || width);
  // @ts-ignore
  const graphics = scene.add.graphics({ fillStyle: { color: COLOR[color] } });
  graphics.fillRectShape(rect);
  return graphics;
};

export default createColorRectangle;

// // globalResourceKey: 0
// const testRectGreen = new Phaser.Geom.Rectangle(200, 200, this.tileScale, this.tileScale);
// const testGraphicsGreen = this.add.graphics({ fillStyle: { color: 0x00ff00 } });
// testGraphicsGreen.fillRectShape(testRectGreen);

// // globalResourceKey: 1
// const testRectBlue = new Phaser.Geom.Rectangle(205, 205, this.tileScale, this.tileScale);
// const testGraphicsBlue = this.add.graphics({ fillStyle: { color: 0x0000ff } });
// testGraphicsBlue.fillRectShape(testRectBlue);

// // globalResourceKey: 2
// const testRectRed = new Phaser.Geom.Rectangle(210, 210, this.tileScale, this.tileScale);
// const testGraphicsRed = this.add.graphics({ fillStyle: { color: 0xff0000 } });
// testGraphicsRed.fillRectShape(testRectRed);

// // globalResourceKey: 3
// const testRectYellow = new Phaser.Geom.Rectangle(215, 215, this.tileScale, this.tileScale);
// const testGraphicsYellow = this.add.graphics({ fillStyle: { color: 0xffff00 } });
// testGraphicsYellow.fillRectShape(testRectYellow);

// // globalResourceKey: 4
// const testRectCyan = new Phaser.Geom.Rectangle(220, 220, this.tileScale, this.tileScale);
// const testGraphicsCyan = this.add.graphics({ fillStyle: { color: 0x00ffff } });
// testGraphicsCyan.fillRectShape(testRectCyan);

// // globalResourceKey: 5
// const testRectPurple = new Phaser.Geom.Rectangle(225, 225, this.tileScale, this.tileScale);
// const testGraphicsPurple = this.add.graphics({ fillStyle: { color: 0xff00ff } });
// testGraphicsPurple.fillRectShape(testRectPurple);
