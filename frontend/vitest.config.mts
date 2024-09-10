import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";
import { resolve } from "node:path";

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": resolve(__dirname, "./"),
      "@services": resolve(__dirname, "./core/services"),
      "@utils": resolve(__dirname, "./core/utils"),
    },
  },
  test: {
    environment: "jsdom",
  },
});
