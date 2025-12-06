import { Hono } from "hono";

const app = new Hono();
const PORT = process.env.PORT || 3103;

app.get("/api/v1/test", (c) => {
  return c.json({
    message: "success",
    timestamp: new Date().toISOString(),
    framework: "Hono.js",
    runtime: "Bun",
  });
});

export default {
  port: PORT,
  fetch: app.fetch,
};

console.log(`Hono.js (Bun) server running on port ${PORT}`);
