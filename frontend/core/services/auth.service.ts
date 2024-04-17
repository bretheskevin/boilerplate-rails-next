import { ApiService } from "@/core/services/api.service";
import { UserJSON } from "@/core/models/user";

export interface DeviseResponse {
  ok: boolean;
  data: DeviseSuccessResponse | DeviseErrorResponse;
}

type DevisePossibleResponse = DeviseSuccessResponse | DeviseErrorResponse;

interface DeviseSuccessResponse {
  expires_in: number;
  refresh_token: string;
  token_type: string;
  token: string;
  resource_owner: JSONObject;
}

interface DeviseErrorResponse {
  error: string;
  error_description: string[];
}

export class AuthService {
  static async register(email: string, password: string): Promise<DeviseResponse> {
    console.log("a");
    const response = await ApiService.post<DevisePossibleResponse>(
      "users/tokens/sign_up",
      { email, password },
    );

    return this._getAuthResponse(response);
  }

  static async login(email: string, password: string): Promise<DeviseResponse> {
    const response = await ApiService.post<DevisePossibleResponse>(
      "users/tokens/sign_in",
      { email, password },
    );

    return this._getAuthResponse(response);
  }

  static async me(): Promise<UserJSON | DeviseErrorResponse> {
    const response = await ApiService.get<UserJSON | DeviseErrorResponse>(
      "users/tokens/info",
    );

    return response;
  }

  static logout(): void {
    localStorage.removeItem("accessToken");
    localStorage.removeItem("refreshToken");
  }

  private static _storeTokens(data: DeviseSuccessResponse): void {
    localStorage.setItem("accessToken", data.token);
    localStorage.setItem("refreshToken", data.refresh_token);
  }

  private static _getAuthResponse(response: DevisePossibleResponse): DeviseResponse {
    const ok = response.hasOwnProperty("token");
    if (ok) {
      this._storeTokens(response as DeviseSuccessResponse);
    }
    return {
      ok,
      data: response,
    };
  }
}
