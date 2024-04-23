import { BaseModel, IBaseModel } from "@/core/models/base_model";

export interface IUser extends IBaseModel {
  email: string;
  role: string;
}

export class UserModel extends BaseModel {
  apiUrl = "users";
  modelParam = "user";

  attributes: IUser = {
    ...this.attributes,
    email: "",
    role: "",
  };
}
