import { create } from "zustand";

interface AuthStore {
  accessToken: string;
  refreshToken: string;
}

export const useAuthStore = create<AuthStore>(() => ({
  accessToken: "",
  refreshToken: "",
}));

export const setAccessToken = (accessToken: string) => {
  useAuthStore.setState({ accessToken });
};

export const setRefreshToken = (refreshToken: string) => {
  useAuthStore.setState({ refreshToken });
};

export const clearTokens = () => {
  useAuthStore.setState({ accessToken: "", refreshToken: "" });
};
