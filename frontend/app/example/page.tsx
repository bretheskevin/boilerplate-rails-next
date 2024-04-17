"use client";

import { AuthService } from "@services/auth.service";
import { User, UserJSON } from "@/core/models/user";
import { EntityManager } from "@/core/entity_manager";

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

  const list = async () => {
    const em: EntityManager<User, UserJSON> = new EntityManager(User);
    const response = await em.list();
    console.log(response);
  };

  const find = async () => {
    const em: EntityManager<User, UserJSON> = new EntityManager(User);
    const response = await em.find(1);
    console.log(response);
  };

  const findNotFound = async () => {
    const em: EntityManager<User, UserJSON> = new EntityManager(User);
    const response = await em.find(0);
    console.log(response);
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

        <button className={buttonStyles} onClick={list}>
          LIST
        </button>

        <button className={buttonStyles} onClick={find}>
          FIND
        </button>

        <button className={buttonStyles} onClick={findNotFound}>
          FIND NOT FOUND
        </button>
      </div>
    </main>
  );
}
