import React from "react";
import Version from "./top/Version";

const Top = () => (
  <div className="p-1 bg-black flex w-screen justify-between">
    <div>
      <span>Ad Finitum ©</span>
      <span> · </span>
      <span>OutlierStudio: {new Date().getFullYear()}</span>
      <span> · </span>
      <a target="_blank" rel="noreferrer" href="https://twitter.com/StudioOutlier">
        twitter
      </a>
      <span> · </span>
      <a
        target="_blank"
        rel="noreferrer"
        href="https://www.youtube.com/channel/UCg25zE5F4u1i8gGlr7CFa6w/videos"
      >
        youtube
      </a>
      {/* <span> · </span> */}
      {/* <a>patreon</a> */}
    </div>
    <Version />
  </div>
);

export default Top;
