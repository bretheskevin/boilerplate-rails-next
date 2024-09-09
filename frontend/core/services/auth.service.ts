import { ApiService } from "@/core/services/api.service";
import { IUser, User } from "@/core/models/user.model";
import { Cookies } from "@/core/utils/client/cookies";

interface DeviseSuccessResponse {
  expires_in: number;
  refresh_token: string;
  token_type: string;
  token: string;
  resource_owner: IUser;
}

export class AuthService {
  static async register(email: string, password: string): Promise<ApiResponse<DeviseSuccessResponse>> {
    const response = await ApiService.post<DeviseSuccessResponse>("users/tokens/sign_up", { email, password });

    this._storeTokens(response);

    return response;
  }

  static async login(email: string, password: string): Promise<ApiResponse<DeviseSuccessResponse>> {
    const response = await ApiService.post<DeviseSuccessResponse>("users/tokens/sign_in", { email, password });

    this._storeTokens(response);
    return response;
  }

  static async me(): Promise<ApiResponse<User>> {
    const response: ApiResponse<IUser> = await ApiService.get<IUser>("users/tokens/info");

    if (response.ok) {
      const user = new User();
      user.fromJSON(response.data as IUser);
      return { ok: true, data: user };
    }

    return { ok: false, data: response.data as ApiError };
  }

  static logout(): void {
    Cookies.remove(["access_token", "refresh_token"]);
  }

  private static _storeTokens(response: ApiResponse<DeviseSuccessResponse>): void {
    if (!response.ok) {
      this.logout();
      return;
    }
    const { token, refresh_token, expires_in } = response.data as DeviseSuccessResponse;
    const expiration = new Date(Date.now() + expires_in * 1000 * 60 * 30);

    Cookies.set("access_token", token, { expires: expiration, path: "/" });
    Cookies.set("refresh_token", refresh_token, { expires: expiration, path: "/" });
  }
}
