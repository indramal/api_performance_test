export async function GET(request) {
  return Response.json({
    message: "success",
    timestamp: new Date().toISOString(),
    framework: "Next.js",
    runtime: "Node.js",
  });
}
