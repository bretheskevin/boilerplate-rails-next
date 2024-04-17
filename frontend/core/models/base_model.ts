export interface BaseModelJSON {
  id: number;
  created_at: string;
  updated_at: string;
}

export abstract class BaseModel {
  abstract apiUrl: string;

  attributes: BaseModelJSON = {
    id: 0,
    created_at: "",
    updated_at: "",
  };
}
