declare type JSONObject = {
  [key: string]: string | number | boolean | JSONObject | JSONObject[] | null;
};
