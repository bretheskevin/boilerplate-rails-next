import { BaseModel, IBaseModel } from "@/core/models/base.model";

export interface IDummy extends IBaseModel {
  name?: string;
  description?: string;
}

export class Dummy extends BaseModel {
  apiUrl = "dummies";
  modelParam = "dummy";

  attributes: IDummy = {
    ...this.attributes,
    name: undefined,
    description: undefined,
  };

  toString(): string {
    return this.attributes.name || "Dummy";
  }
}
