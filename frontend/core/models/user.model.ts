import { BaseModel, BaseModelJSON } from "@/core/models/base_model";

export interface UserJSON extends BaseModelJSON {
  email: string;
}

export class UserModel extends BaseModel {
  apiUrl = "users";
  modelParam = "user";

  attributes: UserJSON = {
    ...this.attributes,
    email: "",
  };
}
