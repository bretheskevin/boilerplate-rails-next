declare type JSONObject = { [key: string]: any };

declare type ApiError = {
  error: string;
  error_description: string[];
};

declare type ApiResponse<T> = {
  ok: boolean;
  data: T | ApiError;
};
