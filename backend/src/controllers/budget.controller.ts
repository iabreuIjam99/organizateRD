import { Response, NextFunction } from "express";
import { AuthRequest } from "../middlewares/auth.middleware";
import { AppError } from "../middlewares/error.middleware";
import * as budgetService from "../services/budget.service";

export async function listBudgets(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const type = req.query.type as string | undefined;
    const budgets = await budgetService.listBudgets(req.userId!, type);
    res.json({ budgets });
  } catch (err) { next(err); }
}

export async function createBudget(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const { amount, category, period, budgetType } = req.body;
    if (!amount || !category || !period) {
      throw new AppError(400, "VALIDATION_ERROR", "amount, category y period son requeridos");
    }
    const budget = await budgetService.createBudget(req.userId!, { amount, category, period, budgetType });
    res.status(201).json({ budget });
  } catch (err) { next(err); }
}

export async function updateBudget(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const budget = await budgetService.updateBudget(req.userId!, req.params.id, req.body);
    if (!budget) throw new AppError(404, "NOT_FOUND", "Presupuesto no encontrado");
    res.json({ budget });
  } catch (err) { next(err); }
}

export async function deleteBudget(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const deleted = await budgetService.deleteBudget(req.userId!, req.params.id);
    if (!deleted) throw new AppError(404, "NOT_FOUND", "Presupuesto no encontrado");
    res.json({ message: "Eliminado" });
  } catch (err) { next(err); }
}

export async function listGoals(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const goals = await budgetService.listGoals(req.userId!);
    res.json({ goals });
  } catch (err) { next(err); }
}

export async function createGoal(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const { name, targetAmount, icon } = req.body;
    if (!name || !targetAmount) {
      throw new AppError(400, "VALIDATION_ERROR", "name y targetAmount son requeridos");
    }
    const goal = await budgetService.createGoal(req.userId!, { name, targetAmount, icon });
    res.status(201).json({ goal });
  } catch (err) { next(err); }
}

export async function updateGoal(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const goal = await budgetService.updateGoal(req.userId!, req.params.id, req.body);
    if (!goal) throw new AppError(404, "NOT_FOUND", "Meta no encontrada");
    res.json({ goal });
  } catch (err) { next(err); }
}

export async function deleteGoal(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    const deleted = await budgetService.deleteGoal(req.userId!, req.params.id);
    if (!deleted) throw new AppError(404, "NOT_FOUND", "Meta no encontrada");
    res.json({ message: "Eliminada" });
  } catch (err) { next(err); }
}
