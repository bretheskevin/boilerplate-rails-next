declare type JSONObject = { [key: string]: any };

declare type ApiError = {
  error: string;
  error_description: string[];
};

declare type ApiResponse<T> = {
  ok: boolean;
  data: T | ApiError;
};

declare type ApiModelListResponse<T> = {
  models: T[];
  current_page: number;
  total_pages: number;
  per_page: number;
  total_objects: number;
};
