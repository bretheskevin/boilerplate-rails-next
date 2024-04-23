"use client";

import { AuthService } from "@services/auth.service";
import { EntityManager } from "@/core/entity_manager";
import { DummyModel, IDummy } from "@/app/example/dummy.model";
import { useRef } from "react";

const buttonStyles = "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded";
const btnContainerStyles = "flex items-center justify-center gap-4";

export default function Example() {
  const counter = useRef<number>(1);

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
    console.log(response);
  };

  const logLocalStorage = () => {
    console.log("accessToken", localStorage.getItem("accessToken"));
    console.log("refreshToken", localStorage.getItem("refreshToken"));
  };

  const list = async () => {
    const em: EntityManager<DummyModel, IDummy> = new EntityManager(DummyModel);
    const response = await em.list();
    console.log(response);
  };

  const list2 = async () => {
    const em: EntityManager<DummyModel, IDummy> = new EntityManager(DummyModel);
    const response = await em.list({
      page: 2,
      perPage: 10,
    });
    console.log(response);
  };

  const find = async () => {
    const em: EntityManager<DummyModel, IDummy> = new EntityManager(DummyModel);
    const response = await em.find(1);
    console.log(response);
  };

  const findNotFound = async () => {
    const em: EntityManager<DummyModel, IDummy> = new EntityManager(DummyModel);
    const response = await em.find(0);
    console.log(response);
  };

  const create = async () => {
    const em: EntityManager<DummyModel, IDummy> = new EntityManager(DummyModel);
    const response = await em.create({ name: "Dummy", description: "Description" });
    console.log(response);
  };

  const patch = async () => {
    counter.current++;

    const em: EntityManager<DummyModel, IDummy> = new EntityManager(DummyModel);
    const response = await em.update(1, { name: `Dummy Change#${counter.current}`, description: "Description" });
    console.log(response.data!.toString());
  };

  const deleteDummy = async () => {
    console.log("FIND BUTTON SHOULDN'T WORK AFTER THIS");
    const em: EntityManager<DummyModel, IDummy> = new EntityManager(DummyModel);
    const response = await em.delete(1);
    console.log(response);
  };

  return (
    <main className="min-h-screen p-24 flex flex-col justify-center gap-4">
      <div className={btnContainerStyles}>
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

      <div className={btnContainerStyles}>
        <button className={buttonStyles} onClick={me}>
          ME
        </button>

        <button className={buttonStyles} onClick={list}>
          LIST
        </button>

        <button className={buttonStyles} onClick={list2}>
          LIST 2
        </button>

        <button className={buttonStyles} onClick={find}>
          FIND
        </button>

        <button className={buttonStyles} onClick={findNotFound}>
          FIND NOT FOUND
        </button>

        <button className={buttonStyles} onClick={create}>
          CREATE
        </button>
      </div>

      <div className={btnContainerStyles}>
        <button className={buttonStyles} onClick={patch}>
          PATCH
        </button>

        <button className={buttonStyles} onClick={deleteDummy}>
          DELETE
        </button>
      </div>
    </main>
  );
}
