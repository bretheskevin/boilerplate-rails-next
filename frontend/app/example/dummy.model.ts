import { BaseModel, BaseModelJSON } from "@/core/models/base_model";

export interface DummyJSON extends BaseModelJSON {
  name: string;
  description: string;
}

export class DummyModel extends BaseModel {
  apiUrl = "dummies";
  modelParam = "dummy";

  attributes: DummyJSON = {
    ...this.attributes,
    name: "",
    description: "",
  };

  toString(): string {
    return this.attributes.name;
  }
}
