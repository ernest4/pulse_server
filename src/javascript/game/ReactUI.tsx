import React from "react";
import Hover from "./game/systems/ui/reactUi/Hover";
import Left from "./game/systems/ui/reactUi/Left";
import Top from "./game/systems/ui/reactUi/Top";

const ReactUI = () => {
  return (
    <>
      <div className="fixed">
        <Top />
        <Left />
        {/* <Bottom /> */}
      </div>
      <Hover />
    </>
  );
};

export default ReactUI;
