import { Router } from "express";
import { authMiddleware } from "../middlewares/auth.middleware";
import {
  listBudgets, createBudget, updateBudget, deleteBudget,
  listGoals, createGoal, updateGoal, deleteGoal,
} from "../controllers/budget.controller";

const router = Router();

router.use(authMiddleware);

router.get("/", listBudgets);
router.post("/", createBudget);
router.put("/:id", updateBudget);
router.delete("/:id", deleteBudget);

router.get("/goals", listGoals);
router.post("/goals", createGoal);
router.put("/goals/:id", updateGoal);
router.delete("/goals/:id", deleteGoal);

export default router;
