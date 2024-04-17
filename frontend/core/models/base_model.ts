export interface BaseModelJSON {
  id: number;
  created_at: string;
  updated_at: string;
}

export class BaseModel {
  apiUrl: string = "";

  attributes: BaseModelJSON = {
    id: 0,
    created_at: "",
    updated_at: "",
  };

  fromJSON(json: JSONObject): void {
    for (const key in this.attributes) {
      if (json[key]) {
        // @ts-ignore
        this.attributes[key] = json[key];
      }
    }
  }

  toJSON(): JSONObject {
    return this.attributes;
  }
}
