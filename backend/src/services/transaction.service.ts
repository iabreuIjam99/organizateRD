import { TransactionType } from "@prisma/client";
import prisma from "../utils/prisma";

export async function listTransactions(userId: string, query?: {
  type?: string;
  category?: string;
  from?: string;
  to?: string;
}) {
  const where: any = { userId };
  if (query?.type) where.type = query.type;
  if (query?.category) where.category = query.category;
  if (query?.from || query?.to) {
    where.date = {};
    if (query.from) where.date.gte = new Date(query.from);
    if (query.to) where.date.lte = new Date(query.to);
  }
  return prisma.transaction.findMany({ where, orderBy: { date: "desc" } });
}

export async function createTransaction(userId: string, data: {
  amount: number;
  type: string;
  category: string;
  description?: string;
  ncf?: string;
  date?: string;
}) {
  return prisma.transaction.create({
    data: {
      userId,
      amount: data.amount,
      type: data.type as TransactionType,
      category: data.category,
      description: data.description,
      ncf: data.ncf,
      date: data.date ? new Date(data.date) : new Date(),
    },
  });
}

export async function updateTransaction(userId: string, id: string, data: {
  amount?: number;
  type?: string;
  category?: string;
  description?: string;
  ncf?: string;
}) {
  const tx = await prisma.transaction.findFirst({ where: { id, userId } });
  if (!tx) return null;
  return prisma.transaction.update({
    where: { id },
    data: {
      ...(data.amount !== undefined && { amount: data.amount }),
      ...(data.type !== undefined && { type: data.type as TransactionType }),
      ...(data.category !== undefined && { category: data.category }),
      ...(data.description !== undefined && { description: data.description }),
      ...(data.ncf !== undefined && { ncf: data.ncf }),
    },
  });
}

export async function deleteTransaction(userId: string, id: string) {
  const tx = await prisma.transaction.findFirst({ where: { id, userId } });
  if (!tx) return false;
  await prisma.transaction.delete({ where: { id } });
  return true;
}

export async function getDashboard(userId: string) {
  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

  const [totalBalance, monthlyIncome, monthlyExpenses, recentTransactions, budgetCount, goalCount] =
    await Promise.all([
      prisma.transaction.aggregate({
        where: { userId },
        _sum: { amount: true },
      }),
      prisma.transaction.aggregate({
        where: { userId, type: "INCOME", date: { gte: startOfMonth } },
        _sum: { amount: true },
      }),
      prisma.transaction.aggregate({
        where: { userId, type: "EXPENSE", date: { gte: startOfMonth } },
        _sum: { amount: true },
      }),
      prisma.transaction.findMany({
        where: { userId },
        orderBy: { date: "desc" },
        take: 5,
      }),
      prisma.budget.count({ where: { userId } }),
      prisma.goal.count({ where: { userId, status: "ACTIVE" } }),
    ]);

  const income = monthlyIncome._sum.amount || 0;
  const expenses = monthlyExpenses._sum.amount || 0;

  return {
    balance: totalBalance._sum.amount || 0,
    monthlyIncome: income,
    monthlyExpenses: expenses,
    netBalance: income - expenses,
    recentTransactions,
    budgetCount,
    goalCount,
  };
}
