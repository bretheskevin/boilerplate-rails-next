import { AuthService } from "@services/auth.service";
import { EntityManager } from "@/core/entity_manager";
import { Dummy, IDummy } from "@/app/example/dummy";

export default function Example() {
  const me = async () => {
    const response = await AuthService.me();
    console.log(response);
  };

  const list = async () => {
    const em: EntityManager<Dummy, IDummy> = new EntityManager(Dummy);
    const response = await em.list();
    console.log(response);
  };

  me();
  list();

  return <h1>Server</h1>;
}
