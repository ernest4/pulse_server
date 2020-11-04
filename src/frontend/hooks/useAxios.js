import { useEffect, useReducer, useState, useCallback } from "react";
import axios from "axios";
import _debounce from "lodash.debounce";
import useIsMountedRef from "./useIsMountedRef";
import useDebugLog from "./useDebugLog";
import { camelize } from "../utils/Props";

const useAxios = ({
  url: initialUrl,
  method: initialMethod,
  debugLog: enabled,
  onResultsFormat,
  debounce,
  contentType,
} = {}) => {
  const [url, setUrl] = useState(initialUrl);
  // const [method] = useState(initialMethod || "get");
  const isMountedRef = useIsMountedRef();
  const [state, dispatch] = useReducer(dataFetchReducer, { loading: false, error: false });
  const { log } = useDebugLog({ component: "useAxios", enabled });
  const [csrfToken, setCsrfToken] = useState();

  const method = initialMethod || "get";

  useEffect(() => {
    // TODO: read this from redux ??
    // Each page should fetch its own csrf token from back end...
    setCsrfToken(window.document.querySelector("meta[name=csrf-token]").content);
  }, []);

  const [requestParams, setRequestParams] = useState();

  const fetch = useCallback(
    _debounce(
      newParams => {
        if (!newParams) return setRequestParams({ ...{} });

        if (newParams.url) {
          setUrl(newParams.url);
          delete newParams.url;
        }

        // GET -> params, POST/PUT/PATCH -> data
        setRequestParams({ [method === "get" ? "params" : "data"]: newParams });
      },
      debounce || 500,
      { leading: true, trailing: true }
    ),
    [method, debounce]
  );

  useEffect(() => {
    log.info("url", url);
    if (!requestParams || !url) return;

    const fetchData = async () => {
      try {
        dispatch({ type: "FETCH" });
        log.info("working");

        // ONLY SEND TOKEN ON POST REQUEST !!!! on get request token is visible and defeats purpose
        let headers = method === "get" ? {} : { "X-CSRF-Token": csrfToken };
        if (contentType) headers = { ...headers, contentType };

        const response = await axios({
          url,
          method,
          // responseType: "json", // json is default
          ...requestParams,
          headers,
        });

        if (isMountedRef.current) {
          if (onResultsFormat) response.data = onResultsFormat(response.data);

          dispatch({ type: "SUCCESS", payload: response });
          log.success("got response", response);
          log.success(`got ${onResultsFormat ? "formatted" : ""} data`, response.data);
        }
      } catch (e) {
        dispatch({ type: "FAILURE", payload: e });
        log.error("failed", e);
      }
    };

    fetchData();
  }, [csrfToken, isMountedRef, log, method, requestParams, url, onResultsFormat]);

  // TODO: fetch can take in optional params, either get url or post body params
  return { ...state, request: fetch };
};

export default useAxios;

const dataFetchReducer = (state, { type, payload }) => {
  switch (type) {
    case "FETCH":
      return { ...state, loading: true, error: false };
    case "SUCCESS":
      return { ...state, loading: false, error: false, data: payload.data, status: payload.status };
    case "FAILURE":
      return {
        ...state,
        loading: false,
        error: true,
        errorData: payload.data,
        status: payload.status,
      };
    default:
      throw new Error();
  }
};

export const onResultsCamelize = results => results.map(result => camelize(result));
