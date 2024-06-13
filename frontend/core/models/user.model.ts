import { BaseModel, IBaseModel } from "@/core/models/base.model";

export enum UserRole {
  ADMIN = "admin",
  USER = "user",
}

export interface IUser extends IBaseModel {
  email?: string;
  role?: UserRole;
}

export class User extends BaseModel {
  apiUrl = "users";
  modelParam = "user";

  attributes: IUser = {
    ...this.attributes,
    email: undefined,
    role: undefined,
  };

  isAdmin(): boolean {
    return this.attributes.role === UserRole.ADMIN;
  }
}
