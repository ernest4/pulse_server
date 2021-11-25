import React from "react";
import { useSelector } from "react-redux";

const Hover = () => {
  const hover = useSelector((state: any) => state.hover);
  const hoverX = useSelector((state: any) => state.hoverX);
  const hoverY = useSelector((state: any) => state.hoverY);

  return (
    <div className="absolute" style={{ top: hoverY, left: hoverX }}>
      {hover}
    </div>
  );
};

export default Hover;
