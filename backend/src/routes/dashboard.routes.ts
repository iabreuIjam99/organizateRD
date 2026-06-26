import { Router } from "express";
import { authMiddleware } from "../middlewares/auth.middleware";
import { getDashboard } from "../controllers/transaction.controller";

const router = Router();

router.use(authMiddleware);

router.get("/", getDashboard);

export default router;
