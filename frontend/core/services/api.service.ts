import { useAuthStore } from "@/stores/auth.store";

export class ApiService {
  private static _baseUrl: string = "http://127.0.0.1/api/";

  static async get<T>(url: string, params: JSONObject = {}): Promise<ApiResponse<T>> {
    const response = await fetch(this._buildUrl(url, params), {
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

  static async delete(url: string): Promise<ApiResponse<null>> {
    const response = await fetch(this._buildUrl(url), {
      method: "DELETE",
    });

    return await this._buildResponse<null>(response);
  }

  private static _buildUrl(path: string, params: JSONObject = {}): string {
    const url: URL = new URL(path, this._baseUrl);

    for (const [key, value] of Object.entries(params)) {
      const snakeKey = key.replace(/([A-Z])/g, "_$1").toLowerCase();
      url.searchParams.append(snakeKey, value);
    }

    return url.toString();
  }

  private static _buildHeaders(): { [key: string]: string } {
    return {
      "Content-Type": "application/json",
      Authorization: `Bearer ${useAuthStore.getState().accessToken}`,
    };
  }

  private static async _buildResponse<T>(response: Response): Promise<ApiResponse<T>> {
    const data = response.status === 204 ? null : await response.json();

    return {
      ok: response.ok,
      data,
    };
  }
}
