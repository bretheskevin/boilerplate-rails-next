import { describe, expect, it } from "vitest";
import { Cookies } from "@utils/cookies";

describe("Cookies", () => {
  describe("get", () => {
    it("should return undefined if the cookie does not exist", async () => {
      Object.defineProperty(document, "cookie", {
        writable: true,
        value: "",
      });

      const value = await Cookies.get("nonExistentCookie");
      expect(value).toBeUndefined();
    });

    it("should return the cookie value if the cookie exists", async () => {
      Object.defineProperty(document, "cookie", {
        writable: true,
        value: "testCookie=testValue",
      });

      const value = await Cookies.get("testCookie");
      expect(value).toBe("testValue");
    });
  });

  describe("set", () => {
    it("should set a cookie with the given name and value", () => {
      Object.defineProperty(document, "cookie", {
        writable: true,
        value: "",
      });

      Cookies.set("testCookie", "testValue");
      expect(document.cookie).toBe("testCookie=testValue");
    });

    it("should set a cookie with the given expiration date", () => {
      Object.defineProperty(document, "cookie", {
        writable: true,
        value: "",
      });

      const expires = new Date(Date.now() + 86400000); // 1 day from now
      Cookies.set("testCookie", "testValue", { expires });
      expect(document.cookie).toContain("expires=");
    });
  });

  describe("remove", () => {
    it("should remove a single cookie", () => {
      Object.defineProperty(document, "cookie", {
        writable: true,
        value: "testCookie=testValue",
      });

      Cookies.remove("testCookie");
      expect(document.cookie).toContain("expires=");
    });

    it("should remove multiple cookies", () => {
      Object.defineProperty(document, "cookie", {
        writable: true,
        value: "testCookie1=testValue1; testCookie2=testValue2",
      });

      Cookies.remove(["testCookie1", "testCookie2"]);
      expect(document.cookie).toContain("expires=");
    });
  });
});
