type JSONObject = { [key: string]: any };

type ApiError = {
  error: string;
  error_description: string[];
};

type ApiResponse<T> = {
  ok: boolean;
  data: T | ApiError;
};

type ApiModelListResponse<T> = {
  models: T[];
  current_page: number;
  total_pages: number;
  per_page: number;
  total_objects: number;
};
