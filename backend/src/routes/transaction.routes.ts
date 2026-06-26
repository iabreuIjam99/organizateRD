import { Router } from "express";
import { authMiddleware } from "../middlewares/auth.middleware";
import {
  listTransactions, createTransaction, updateTransaction, deleteTransaction,
  getDashboard,
} from "../controllers/transaction.controller";

const router = Router();

router.use(authMiddleware);

router.get("/", listTransactions);
router.post("/", createTransaction);
router.put("/:id", updateTransaction);
router.delete("/:id", deleteTransaction);

export default router;
