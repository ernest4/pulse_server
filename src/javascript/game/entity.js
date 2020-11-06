import store from "./store";
import * as gameActions from "./store/actions/game";

const initEntity = ({ scene, x, y, key, imageOnly }) => {
  const TINT = {
    grass: 0xff0000,
    turtle: 0x0000ff,
    shark: 0x00ff00,
  };

  // TODO: handle imageOnly => true case.
  // use: scene.add.image() ...
  // otherwise use: scene.add.sprite() ...
  // difference is, sprites can be animated and thus are more expensive

  // TODO: tweens https://phaser.io/examples/v3/category/tweens

  const entity = scene.add
    .image(100 * x, 100 * y, key)
    .setOrigin(0)
    .setDisplaySize(100, 100);

  entity.setInteractive();
  entity.on("pointerdown", pointer => {
    if (pointer.rightButtonDown()) store.dispatch(gameActions.setTargetTile([x, y]));
    else store.dispatch(gameActions.setActiveTile([x, y]));
    entity.setTint(TINT[key]);
  });
  entity.on("pointerout", pointer => {
    entity.clearTint();
  });

  entity.setInteractive();
  entity.on("pointerup", pointer => {
    entity.clearTint();
  });

  return entity;
};

export default initEntity;
