import { BaseModel, IBaseModel } from "@/core/models/base_model";

export interface IDummy extends IBaseModel {
  name?: string;
  description?: string;
}

export class DummyModel extends BaseModel {
  apiUrl = "dummies";
  modelParam = "dummy";

  attributes: IDummy = {
    ...this.attributes,
  };

  toString(): string {
    return this.attributes.name || "Dummy";
  }
}
