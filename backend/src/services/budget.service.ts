import { BudgetPeriod, BudgetType, GoalStatus } from "@prisma/client";
import prisma from "../utils/prisma";

export async function listBudgets(userId: string, type?: string) {
  return prisma.budget.findMany({
    where: { userId, ...(type ? { budgetType: type as BudgetType } : {}) },
    orderBy: { createdAt: "desc" },
  });
}

export async function createBudget(userId: string, data: {
  amount: number;
  category: string;
  period: string;
  budgetType?: string;
}) {
  return prisma.budget.create({
    data: {
      userId,
      amount: data.amount,
      category: data.category,
      period: data.period as BudgetPeriod,
      budgetType: (data.budgetType as BudgetType) || "PERSONAL",
    },
  });
}

export async function updateBudget(userId: string, id: string, data: {
  amount?: number;
  spent?: number;
  category?: string;
  period?: string;
}) {
  const budget = await prisma.budget.findFirst({ where: { id, userId } });
  if (!budget) return null;
  return prisma.budget.update({
    where: { id },
    data: {
      ...(data.amount !== undefined && { amount: data.amount }),
      ...(data.spent !== undefined && { spent: data.spent }),
      ...(data.category !== undefined && { category: data.category }),
      ...(data.period !== undefined && { period: data.period as BudgetPeriod }),
    },
  });
}

export async function deleteBudget(userId: string, id: string) {
  const budget = await prisma.budget.findFirst({ where: { id, userId } });
  if (!budget) return false;
  await prisma.budget.delete({ where: { id } });
  return true;
}

export async function listGoals(userId: string) {
  return prisma.goal.findMany({
    where: { userId },
    orderBy: { createdAt: "desc" },
  });
}

export async function createGoal(userId: string, data: {
  name: string;
  targetAmount: number;
  icon?: string;
}) {
  return prisma.goal.create({
    data: {
      userId,
      name: data.name,
      targetAmount: data.targetAmount,
      icon: data.icon,
    },
  });
}

export async function updateGoal(userId: string, id: string, data: {
  name?: string;
  targetAmount?: number;
  currentAmount?: number;
  icon?: string;
  status?: string;
}) {
  const goal = await prisma.goal.findFirst({ where: { id, userId } });
  if (!goal) return null;
  return prisma.goal.update({
    where: { id },
    data: {
      ...(data.name !== undefined && { name: data.name }),
      ...(data.targetAmount !== undefined && { targetAmount: data.targetAmount }),
      ...(data.currentAmount !== undefined && { currentAmount: data.currentAmount }),
      ...(data.icon !== undefined && { icon: data.icon }),
      ...(data.status !== undefined && { status: data.status as GoalStatus }),
    },
  });
}

export async function deleteGoal(userId: string, id: string) {
  const goal = await prisma.goal.findFirst({ where: { id, userId } });
  if (!goal) return false;
  await prisma.goal.delete({ where: { id } });
  return true;
}
