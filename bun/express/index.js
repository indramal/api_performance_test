import express from "express";

const app = express();
const PORT = process.env.PORT || 3101;

app.get("/api/v1/test", (req, res) => {
  res.json({
    message: "success",
    timestamp: new Date().toISOString(),
    framework: "Express.js",
    runtime: "Bun",
  });
});

app.listen(PORT, () => {
  console.log(`Express.js (Bun) server running on port ${PORT}`);
});
