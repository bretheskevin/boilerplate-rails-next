export class ApiService {
  private static _baseUrl: string = "/api/";

  static async get<T>(url: string): Promise<ApiResponse<T>> {
    const response = await fetch(this._buildUrl(url), {
      method: "GET",
      headers: this._buildHeaders(),
    });

    return await this._buildResponse<T>(response);
  }

  static async post<T>(url: string, body: JSONObject): Promise<ApiResponse<T>> {
    const response = await fetch(this._buildUrl(url), {
      method: "POST",
      headers: this._buildHeaders(),
      body: JSON.stringify(body),
    });

    return await this._buildResponse<T>(response);
  }

  static async patch<T>(url: string, body: JSONObject): Promise<ApiResponse<T>> {
    const response = await fetch(this._buildUrl(url), {
      method: "PATCH",
      headers: this._buildHeaders(),
      body: JSON.stringify(body),
    });

    return await this._buildResponse<T>(response);
  }

  static async delete<T>(url: string): Promise<ApiResponse<T>> {
    const response = await fetch(this._buildUrl(url), {
      method: "DELETE",
    });

    return await this._buildResponse<T>(response);
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

  private static async _buildResponse<T>(
    response: Response,
  ): Promise<ApiResponse<T>> {
    const data = await response.json();

    return {
      ok: response.ok,
      data,
    };
  }
}
