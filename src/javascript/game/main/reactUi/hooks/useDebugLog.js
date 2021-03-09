/* eslint-disable no-console */
import { useState } from "react";

const useDebugLog = ({ component, enabled }) => {
  const [logObject] = useState({
    ...log({ component, type: "success", enabled }),
    ...log({ component, type: "error", enabled }),
    ...log({ component, type: "info", enabled }),
    ...log({ component, type: "warning", enabled }),
  });

  return { log: logObject };
};

export default useDebugLog;

const log = ({ component, type, enabled }) => ({
  [type]: enabled
    ? (message, data) => {
        console.log(`(PGS_LOG: begin) > ${component} > ${type} > ${message}`);
        if (data) console.log(data);
        console.log(`(PGS_LOG: end) -------------------------------------`);
      }
    : () => {},
});
