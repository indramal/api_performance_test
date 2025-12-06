import Fastify from "fastify";

const fastify = Fastify({
  logger: false,
});

const PORT = process.env.PORT || 3002;

fastify.get("/api/v1/test", async (request, reply) => {
  return {
    message: "success",
    timestamp: new Date().toISOString(),
    framework: "Fastify.js",
    runtime: "Node.js",
  };
});

const start = async () => {
  try {
    await fastify.listen({ port: PORT, host: "0.0.0.0" });
    console.log(`Fastify.js server running on port ${PORT}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
