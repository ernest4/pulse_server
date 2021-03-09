import React from "react";
import Hover from "./reactUi/Hover";
import Left from "./reactUi/Left";
import Top from "./reactUi/Top";

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
