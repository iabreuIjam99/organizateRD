import express from "express";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get("/api/health", (_req, res) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
    service: "organizaterd-backend",
  });
});

app.listen(PORT, () => {
  console.log(`[organizaterd] Server running on port ${PORT}`);
});

export default app;
