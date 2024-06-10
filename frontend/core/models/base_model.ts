export interface IBaseModel {
  id?: number;
  created_at?: string;
  updated_at?: string;
}

export class BaseModel {
  apiUrl: string = "";
  modelParam: string = "";

  attributes: IBaseModel = {};

  fromJSON(json: JSONObject): void {
    for (const key in this.attributes) {
      if (json[key]) {
        // @ts-ignore
        this.attributes[key] = json[key];
      }
    }
  }

  toString(): string {
    return this.attributes.id?.toString() || "";
  }
}
