import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import authRoutes from "./routes/auth.routes";
import budgetRoutes from "./routes/budget.routes";
import transactionRoutes from "./routes/transaction.routes";
import dashboardRoutes from "./routes/dashboard.routes";
import { errorMiddleware } from "./middlewares/error.middleware";

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

app.use("/api/auth", authRoutes);
app.use("/api/budgets", budgetRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/dashboard", dashboardRoutes);

app.use(errorMiddleware);

app.listen(PORT, () => {
  console.log(`[organizaterd] Server running on port ${PORT}`);
});

export default app;
