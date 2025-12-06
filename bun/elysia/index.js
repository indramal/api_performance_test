import { Elysia } from "elysia";

const PORT = process.env.PORT || 3104;

const app = new Elysia()
  .get("/api/v1/test", () => ({
    message: "success",
    timestamp: new Date().toISOString(),
    framework: "Elysia.js",
    runtime: "Bun",
  }))
  .listen(PORT);

console.log(`Elysia.js server running on port ${PORT}`);
