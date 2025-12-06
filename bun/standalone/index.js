const PORT = process.env.PORT || 3106;

Bun.serve({
  port: PORT,
  fetch(req) {
    const url = new URL(req.url);

    if (url.pathname === "/api/v1/test") {
      return Response.json({
        message: "success",
        timestamp: new Date().toISOString(),
        framework: "Standalone",
        runtime: "Bun",
      });
    }

    return new Response("Not Found", { status: 404 });
  },
});

console.log(`Bun standalone server running on port ${PORT}`);
