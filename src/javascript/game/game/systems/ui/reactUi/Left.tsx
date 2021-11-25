import React from "react";

const Left = () => {
  // useEffect(() => {
  //   window.addEventListener("resize", handleResize);
  //   return () => {
  //     window.removeEventListener("resize", handleResize);
  //   };
  // }, []);

  return (
    <div
      style={{
        position: "absolute",
        left: 0,
        width: 50,
        height: "100vh",
        backgroundColor: "yellow",
        opacity: 0.5,
      }}
    />
  );
};

export default Left;
