import { Response, NextFunction } from "express";
import { AuthRequest } from "../middlewares/auth.middleware";
import { AppError } from "../middlewares/error.middleware";
import * as txService from "../services/transaction.service";

export async function listTransactions(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const { type, category, from, to } = req.query as Record<string, string | undefined>;
    const transactions = await txService.listTransactions(req.userId!, { type, category, from, to });
    res.json({ transactions });
  } catch (err) { next(err); }
}

export async function createTransaction(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const { amount, type, category, description, ncf, date } = req.body;
    if (!amount || !type || !category) {
      throw new AppError(400, "VALIDATION_ERROR", "amount, type y category son requeridos");
    }
    if (!["INCOME", "EXPENSE"].includes(type)) {
      throw new AppError(400, "VALIDATION_ERROR", "type debe ser INCOME o EXPENSE");
    }
    const transaction = await txService.createTransaction(req.userId!, { amount, type, category, description, ncf, date });
    res.status(201).json({ transaction });
  } catch (err) { next(err); }
}

export async function updateTransaction(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const transaction = await txService.updateTransaction(req.userId!, req.params.id, req.body);
    if (!transaction) throw new AppError(404, "NOT_FOUND", "Transacción no encontrada");
    res.json({ transaction });
  } catch (err) { next(err); }
}

export async function deleteTransaction(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const deleted = await txService.deleteTransaction(req.userId!, req.params.id);
    if (!deleted) throw new AppError(404, "NOT_FOUND", "Transacción no encontrada");
    res.json({ message: "Eliminada" });
  } catch (err) { next(err); }
}

export async function getDashboard(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const dashboard = await txService.getDashboard(req.userId!);
    res.json(dashboard);
  } catch (err) { next(err); }
}
