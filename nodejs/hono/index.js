import { Hono } from "hono";
import { serve } from "@hono/node-server";

const app = new Hono();
const PORT = process.env.PORT || 3003;

app.get("/api/v1/test", (c) => {
  return c.json({
    message: "success",
    timestamp: new Date().toISOString(),
    framework: "Hono.js",
    runtime: "Node.js",
  });
});

serve(
  {
    fetch: app.fetch,
    port: PORT,
  },
  (info) => {
    console.log(`Hono.js server running on port ${info.port}`);
  }
);
