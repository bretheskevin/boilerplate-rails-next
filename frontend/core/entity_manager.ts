import { BaseModel, BaseModelJSON } from "@/core/models/base_model";
import { ApiService } from "@services/api.service";
import { ApiError } from "next/dist/server/api-utils";

export class EntityManager<T extends BaseModel, U extends BaseModelJSON> {
  private _apiUrl: string = "";
  public _modelClass: typeof BaseModel;

  constructor(modelClass: typeof BaseModel) {
    this._setApiUrl(modelClass);
    this._modelClass = modelClass;
  }

  async list(): Promise<T[] | ApiError> {
    // @ts-ignore
    const response: U[] | ApiError = await ApiService.get<U[]>(this._apiUrl);

    if (ApiService.isApiError(response)) {
      return response as ApiError;
    }

    return (response as U[]).map((item) => {
      return this._modelFromJSON(item);
    });
  }

  async find(id: number): Promise<T | ApiError> {
    // @ts-ignore
    const response: U | ApiError = await ApiService.get<U>(`${this._apiUrl}/${id}`);

    if (ApiService.isApiError(response)) {
      return response as ApiError;
    }

    return this._modelFromJSON(response as U);
  }

  private _setApiUrl(modelClass: typeof BaseModel): void {
    const model = new modelClass();
    this._apiUrl = model.apiUrl;
  }

  private _modelFromJSON(json: U): T {
    const model = new this._modelClass() as T;
    model.fromJSON(json);
    return model;
  }
}
