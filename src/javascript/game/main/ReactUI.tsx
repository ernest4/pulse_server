import React from "react";
import Left from "./reactUi/Left";
import Top from "./reactUi/Top";

const ReactUI = () => {
  // const showUi = useSelector(state => state.showUi);

  return (
    <div className="fixed">
      <Top />
      <Left />
      {/* <Bottom /> */}
      {/* <Hover /> */}
    </div>
  );
};

export default ReactUI;
