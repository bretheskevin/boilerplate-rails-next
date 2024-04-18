import { BaseModel, BaseModelJSON } from "@/core/models/base_model";
import { ApiService } from "@services/api.service";

export class EntityManager<T extends BaseModel, U extends BaseModelJSON> {
  private _apiUrl: string = "";
  public _modelClass: typeof BaseModel;

  constructor(modelClass: typeof BaseModel) {
    this._setApiUrl(modelClass);
    this._modelClass = modelClass;
  }

  async list(): Promise<ApiResponse<T[]>> {
    let data: T[] = [];
    const response: ApiResponse<U[]> = await ApiService.get<U[]>(this._apiUrl);

    if (response.ok) {
      data = (response.data as U[]).map((item) => this._modelFromJSON(item));
    }

    return {
      ok: response.ok,
      data: response.ok ? data : (response.data as ApiError),
    };
  }

  async find(id: number): Promise<ApiResponse<T>> {
    let data: T;
    const response: ApiResponse<U> = await ApiService.get<U>(
      `${this._apiUrl}/${id}`,
    );

    if (response.ok) {
      data = this._modelFromJSON(response.data as U);
    }

    return {
      ok: response.ok,
      data: response.ok ? data! : (response.data as ApiError),
    };
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
