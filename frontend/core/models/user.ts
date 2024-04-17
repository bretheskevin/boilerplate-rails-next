import { BaseModel, BaseModelJSON } from "@/core/models/base_model";

export interface UserJSON extends BaseModelJSON {
  email: string;
}

export class User extends BaseModel {
  apiUrl = "users";

  attributes: UserJSON = {
    ...this.attributes,
    email: "",
  };
}
