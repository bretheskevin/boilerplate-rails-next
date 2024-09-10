interface SetCookieOptions {
  path?: string;
  domain?: string;
  expires?: Date;
  secure?: boolean;
}

export class Cookies {
  static async get(name: string): Promise<string | undefined> {
    if (typeof window === "undefined") {
      const cookies = await import("next/headers").then((mod) => mod.cookies);

      const cookieStore = cookies();
      return cookieStore.get(name)?.value;
    }

    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);

    if (parts.length === 2) {
      return parts.pop()!.split(";").shift();
    }

    return undefined;
  }

  static set(name: string, value: string, options?: SetCookieOptions): void {
    options = options || {};

    const expires = options.expires;

    if (expires) {
      const updatedCookie = `${name}=${value}; expires=${expires.toUTCString()}`;
      document.cookie = updatedCookie;
    } else {
      document.cookie = `${name}=${value}`;
    }
  }

  static remove(name: string | string[]): void {
    if (typeof name === "string") {
      this.set(name, "", { expires: new Date(Date.now() - 1) });
    } else {
      name.forEach((n) => this.set(n, "", { expires: new Date(Date.now() - 1) }));
    }
  }
}
