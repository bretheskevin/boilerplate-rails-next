export class ApiService {
  private static _baseUrl: string = "/api/";

  static async get<T>(url: string): Promise<T | ApiError> {
    const response = await fetch(this._buildUrl(url), {
      method: "GET",
      headers: this._buildHeaders(),
    });
    return (await response.json()) as Promise<T | ApiError>;
  }

  static async post<T>(url: string, body: JSONObject): Promise<T | ApiError> {
    const response = await fetch(this._buildUrl(url), {
      method: "POST",
      headers: this._buildHeaders(),
      body: JSON.stringify(body),
    });
    return (await response.json()) as Promise<T | ApiError>;
  }

  static async patch<T>(url: string, body: JSONObject): Promise<T | ApiError> {
    const response = await fetch(this._buildUrl(url), {
      method: "PATCH",
      headers: this._buildHeaders(),
      body: JSON.stringify(body),
    });
    return (await response.json()) as Promise<T | ApiError>;
  }

  static async delete<T>(url: string): Promise<T | ApiError> {
    const response = await fetch(this._buildUrl(url), {
      method: "DELETE",
    });
    return (await response.json()) as Promise<T | ApiError>;
  }

  static isApiError(json: JSONObject): boolean {
    return json.hasOwnProperty("error") && json.hasOwnProperty("error_description");
  }

  private static _buildUrl(path: string): string {
    const url: URL = new URL(this._baseUrl + path, window.location.origin);
    return url.toString();
  }

  private static _buildHeaders(): { [key: string]: string } {
    return {
      "Content-Type": "application/json",
      Authorization: `Bearer ${localStorage.getItem("accessToken")}`,
    };
  }
}
