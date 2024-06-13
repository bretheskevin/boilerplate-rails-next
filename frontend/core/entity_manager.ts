import { BaseModel, IBaseModel } from "@/core/models/base.model";
import { ApiService } from "@services/api.service";

export interface ListParams {
  page?: number;
  perPage?: number;
}

export class EntityManager<T extends BaseModel, U extends IBaseModel> {
  public _modelClass: typeof BaseModel;
  public _modelInstance: T;
  private readonly _apiUrl: string = "";

  constructor(modelClass: typeof BaseModel) {
    this._modelClass = modelClass;
    this._modelInstance = new modelClass() as T;
    this._apiUrl = this._modelInstance.apiUrl;
  }

  async list(params: ListParams = {}): Promise<ApiResponse<ApiModelListResponse<T>>> {
    const response: ApiResponse<ApiModelListResponse<U>> = await ApiService.get<ApiModelListResponse<U>>(
      this._apiUrl,
      params,
    );

    let data: ApiModelListResponse<T> | ApiError = response.ok
      ? this._transformListResponse(response.data as ApiModelListResponse<U>)
      : (response.data as ApiError);

    return {
      ok: response.ok,
      data: data,
    };
  }

  async find(id: number): Promise<ApiResponse<T>> {
    let data: T;
    const response: ApiResponse<U> = await ApiService.get<U>(`${this._apiUrl}/${id}`);

    if (response.ok) {
      data = this._modelFromJSON(response.data as U);
    }

    return {
      ok: response.ok,
      data: response.ok ? data! : (response.data as ApiError),
    };
  }

  async create(body: JSONObject): Promise<ApiResponse<T>> {
    let data: T;
    const response: ApiResponse<U> = await ApiService.post<U>(this._apiUrl, this._bodyWithModelParam(body));

    if (response.ok) {
      data = this._modelFromJSON(response.data as U);
    }

    return {
      ok: response.ok,
      data: response.ok ? data! : (response.data as ApiError),
    };
  }

  async update(id: number, body: JSONObject): Promise<ApiResponse<T>> {
    let data: T;
    const response: ApiResponse<U> = await ApiService.patch<U>(`${this._apiUrl}/${id}`, this._bodyWithModelParam(body));

    if (response.ok) {
      data = this._modelFromJSON(response.data as U);
    }

    return {
      ok: response.ok,
      data: response.ok ? data! : (response.data as ApiError),
    };
  }

  async delete(id: number): Promise<ApiResponse<null>> {
    const response: ApiResponse<null> = await ApiService.delete(`${this._apiUrl}/${id}`);

    return {
      ok: response.ok,
      data: response.ok ? null : (response.data as ApiError),
    };
  }

  private _modelFromJSON(json: U): T {
    const model = new this._modelClass() as T;
    model.fromJSON(json);
    return model;
  }

  private _bodyWithModelParam(body: JSONObject): JSONObject {
    const bodyWithParam: JSONObject = {};
    const modelParam: string = this._modelInstance.modelParam;

    bodyWithParam[modelParam] = body;

    return bodyWithParam;
  }

  private _transformListResponse(apiResponse: ApiModelListResponse<U>): ApiModelListResponse<T> {
    const models = apiResponse.models.map((modelJSON: U) => this._modelFromJSON(modelJSON));

    const transformedResponse: ApiModelListResponse<T> = {
      ...apiResponse,
      models,
    };

    return transformedResponse;
  }
}
