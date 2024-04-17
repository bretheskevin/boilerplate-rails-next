"use client";

import { AuthService } from "@services/auth.service";
import { User } from "@/core/models/user";

const buttonStyles =
  "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded";

export default function Example() {
  const register = async () => {
    const response = await AuthService.register("example@gmail.com", "password");
    console.log(response);
  };

  const login = async () => {
    const response = await AuthService.login("example@gmail.com", "password");
    console.log(response);
  };

  const logout = () => {
    AuthService.logout();
  };

  const me = async () => {
    const response = await AuthService.me();

    if (response.hasOwnProperty("id")) {
      const user = new User();
      user.fromJSON(response);
      console.log(user);
    }
  };

  const logLocalStorage = () => {
    console.log("accessToken", localStorage.getItem("accessToken"));
    console.log("refreshToken", localStorage.getItem("refreshToken"));
  };

  return (
    <main className="min-h-screen p-24 flex flex-col justify-center gap-4">
      <div className={"flex items-center justify-center gap-4"}>
        <button className={buttonStyles} onClick={register}>
          REGISTER
        </button>
        <button className={buttonStyles} onClick={login}>
          LOGIN
        </button>
        <button className={buttonStyles} onClick={logout}>
          LOGOUT
        </button>
        <button className={buttonStyles} onClick={logLocalStorage}>
          LOG LOCAL STORAGE
        </button>
      </div>

      <div className={"flex items-center justify-center gap-4"}>
        <button className={buttonStyles} onClick={me}>
          ME
        </button>
      </div>
    </main>
  );
}
