import {ApiService} from "@/core/services/api.service";
import {IUser, User} from "@/core/models/user";

interface DeviseSuccessResponse {
  expires_in: number;
  refresh_token: string;
  token_type: string;
  token: string;
  resource_owner: IUser;
}

export class AuthService {
  static async register(email: string, password: string): Promise<ApiResponse<DeviseSuccessResponse>> {
    const response = await ApiService.post<DeviseSuccessResponse>("users/tokens/sign_up", {email, password});

    this._storeTokens(response);

    return response;
  }

  static async login(email: string, password: string): Promise<ApiResponse<DeviseSuccessResponse>> {
    const response = await ApiService.post<DeviseSuccessResponse>("users/tokens/sign_in", {email, password});

    this._storeTokens(response);
    return response;
  }

  static async me(): Promise<ApiResponse<User>> {
    const response: ApiResponse<IUser> = await ApiService.get<IUser>("users/tokens/info");

    if (response.ok) {
      const user = new User();
      user.fromJSON(response.data as IUser);
      return {ok: true, data: user};
    }

    return {ok: false, data: response.data as ApiError};
  }

  static logout(): void {
    localStorage.removeItem("accessToken");
    localStorage.removeItem("refreshToken");
  }

  private static _storeTokens(response: ApiResponse<DeviseSuccessResponse>): void {
    if (!response.ok) return;

    const data = response.data as DeviseSuccessResponse;
    localStorage.setItem("accessToken", data.token);
    localStorage.setItem("refreshToken", data.refresh_token);
  }
}
