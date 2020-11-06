const DEBUG = process.env.DEBUG_LOG === "true" || process.env.NODE_ENV !== "production";

exports.log = msg => console.log(`[Pulse]: ${msg}`);

exports.debugLog = msg => {
  if (DEBUG) console.log(`[Pulse]: ${msg}`);
};
