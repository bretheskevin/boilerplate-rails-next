"use client";

import { AuthService } from "@services/auth.service";
import { EntityManager } from "@/core/entity_manager";
import { Dummy, IDummy } from "@/app/example/dummy";
import { useRef } from "react";
import { Button } from "@/components/ui/button";

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
    const em: EntityManager<Dummy, IDummy> = new EntityManager(Dummy);
    const response = await em.list();
    console.log(response);
  };

  const list2 = async () => {
    const em: EntityManager<Dummy, IDummy> = new EntityManager(Dummy);
    const response = await em.list({
      page: 2,
      perPage: 10,
    });
    console.log(response);
  };

  const find = async () => {
    const em: EntityManager<Dummy, IDummy> = new EntityManager(Dummy);
    const response = await em.find(1);
    console.log(response);
  };

  const findNotFound = async () => {
    const em: EntityManager<Dummy, IDummy> = new EntityManager(Dummy);
    const response = await em.find(0);
    console.log(response);
  };

  const create = async () => {
    const em: EntityManager<Dummy, IDummy> = new EntityManager(Dummy);
    const response = await em.create({ name: "Dummy", description: "Description" });
    console.log(response);
  };

  const patch = async () => {
    counter.current++;

    const em: EntityManager<Dummy, IDummy> = new EntityManager(Dummy);
    const response = await em.update(1, { name: `Dummy Change#${counter.current}`, description: "Description" });
    console.log(response.data);
    console.log(response.data.toString());
  };

  const deleteDummy = async () => {
    console.log("FIND BUTTON SHOULDN'T WORK AFTER THIS");
    const em: EntityManager<Dummy, IDummy> = new EntityManager(Dummy);
    const response = await em.delete(1);
    console.log(response);
  };

  return (
    <main className="min-h-screen flex flex-col items-center justify-center gap-4">
      <div className={"flex gap-2"}>
        <Button onClick={register}>REGISTER</Button>
        <Button onClick={login}>LOGIN</Button>
        <Button onClick={logout}>LOGOUT</Button>
        <Button onClick={logLocalStorage}>LOG LOCAL STORAGE</Button>
      </div>

      <div className={"flex gap-2"}>
        <Button onClick={me}>ME</Button>

        <Button onClick={list}>LIST</Button>

        <Button onClick={list2}>LIST 2</Button>

        <Button onClick={find}>FIND</Button>

        <Button onClick={findNotFound}>FIND NOT FOUND</Button>

        <Button onClick={create}>CREATE</Button>
      </div>

      <div className={"flex gap-2"}>
        <Button onClick={patch}>PATCH</Button>

        <Button onClick={deleteDummy}>DELETE</Button>
      </div>
    </main>
  );
}

// import { Dummy, IDummy } from "@/app/example/dummy";
// import { EntityManager } from "@/core/entity_manager";
//
// export default async function Example() {
//   const em: EntityManager<Dummy, IDummy> = new EntityManager(Dummy);
//   const response = await em.list();
//   const data = response.data as ApiModelListResponse<Dummy>;
//
//   return (
//     <main>
//       <h1>Hello world</h1>
//       <ul>
//         {data.models.map((item) => (
//           <li key={item.attributes.id}>{item.attributes.name}</li>
//         ))}
//       </ul>
//     </main>
//   );
// }
