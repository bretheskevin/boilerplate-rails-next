import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";
import path from "node:path";

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./"),
      "@services": path.resolve(__dirname, "./core/services"),
      "@utils": path.resolve(__dirname, "./core/utils"),
    },
  },
  test: {
    environment: "jsdom",
  },
});
