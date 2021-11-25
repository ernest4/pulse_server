import store from "./systems/ui/reactUi/store";
import * as gameActions from "./systems/ui/reactUi/store/actions/game";

const initEntity = ({ scene, x, y, key, imageOnly }: any) => {
  const TINT = {
    grass: 0xff0000,
    water: 0x0000ff,
    block: 0x00ff00,
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
  entity.on("pointerdown", (pointer: any) => {
    if (pointer.rightButtonDown()) store.dispatch(gameActions.setTargetTile([x, y]));
    else store.dispatch(gameActions.setActiveTile([x, y]));
    // @ts-ignore
    entity.setTint(TINT[key]);
  });
  entity.on("pointerout", (pointer: any) => {
    entity.clearTint();
  });

  entity.on("pointerup", (pointer: any) => {
    entity.clearTint();
  });

  return entity;
};

export default initEntity;
