import express from "express";

const app = express();
const PORT = process.env.PORT || 3001;

app.get("/api/v1/test", (req, res) => {
  res.json({
    message: "success",
    timestamp: new Date().toISOString(),
    framework: "Express.js",
    runtime: "Node.js",
  });
});

app.listen(PORT, () => {
  console.log(`Express.js server running on port ${PORT}`);
});
