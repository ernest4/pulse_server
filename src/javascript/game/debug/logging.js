const DEBUG = process.env.DEBUG_LOG === "true" || process.env.NODE_ENV !== "production";

export const log = msg => console.log(`[Pulse Client]: ${msg}`);

export const debugLog = msg => {
  if (DEBUG) console.log(`[Pulse Client]: ${msg}`);
};
