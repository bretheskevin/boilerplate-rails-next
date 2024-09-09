import { Cookies } from "@/core/utils/client/cookies";

export class ApiService {
  static API_BASE_URL_CLIENT: string = "http://127.0.0.1/api/";
  static API_BASE_URL_SERVER: string = "http://backend:3000/";

  private static nodeFetch: any = null;

  static async get<T>(url: string, params: JSONObject = {}): Promise<ApiResponse<T>> {
    const response = await this.adaptativeFetch(this._buildUrl(url, params), {
      method: "GET",
      headers: await this._buildHeaders(),
    });

    return await this._buildResponse<T>(response);
  }

  static async post<T>(url: string, body: JSONObject): Promise<ApiResponse<T>> {
    const response = await this.adaptativeFetch(this._buildUrl(url), {
      method: "POST",
      headers: await this._buildHeaders(),
      body: JSON.stringify(body),
    });

    return await this._buildResponse<T>(response);
  }

  static async patch<T>(url: string, body: JSONObject): Promise<ApiResponse<T>> {
    const response = await this.adaptativeFetch(this._buildUrl(url), {
      method: "PATCH",
      headers: await this._buildHeaders(),
      body: JSON.stringify(body),
    });

    return await this._buildResponse<T>(response);
  }

  static async delete(url: string): Promise<ApiResponse<null>> {
    const response = await this.adaptativeFetch(this._buildUrl(url), {
      method: "DELETE",
    });

    return await this._buildResponse<null>(response);
  }

  private static _buildUrl(path: string, params: JSONObject = {}): string {
    const url: URL = new URL(path, this._baseUrl());

    for (const [key, value] of Object.entries(params)) {
      const snakeKey = key.replace(/([A-Z])/g, "_$1").toLowerCase();
      url.searchParams.append(snakeKey, value);
    }

    return url.toString();
  }

  private static async _buildHeaders(): Promise<{ [key: string]: string }> {
    const accessToken = await Cookies.get("access_token");

    return {
      "Content-Type": "application/json",
      Authorization: `Bearer ${accessToken}`,
    };
  }

  private static async _buildResponse<T>(response: Response): Promise<ApiResponse<T>> {
    const data = response.status === 204 ? null : await response.json();

    return {
      ok: response.ok,
      data,
    };
  }

  private static async adaptativeFetch(url: string, params: RequestInit): Promise<Response> {
    if (typeof window !== "undefined") {
      return fetch(url, params as RequestInit);
    } else {
      if (!this.nodeFetch) {
        this.nodeFetch = (await import("node-fetch")).default;
      }
      return this.nodeFetch(url, params) as Promise<Response>;
    }
  }

  private static _baseUrl() {
    if (typeof window !== "undefined") {
      return this.API_BASE_URL_CLIENT;
    } else {
      return this.API_BASE_URL_SERVER;
    }
  }
}
