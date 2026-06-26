import { PrismaClient, UserType, BudgetPeriod, BudgetType, TransactionType, GoalStatus } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

async function main() {
  console.log("Limpiando datos existentes...");
  await prisma.goal.deleteMany();
  await prisma.transaction.deleteMany();
  await prisma.budget.deleteMany();
  await prisma.user.deleteMany();

  console.log("Creando usuarios...");
  const hash = await bcrypt.hash("123456", 10);

  const elena = await prisma.user.create({
    data: {
      email: "elena@organizate.rd",
      passwordHash: hash,
      name: "Elena Rodriguez",
      rncCedula: "001-1234567-8",
      userType: "PYME",
    },
  });

  const carlos = await prisma.user.create({
    data: {
      email: "carlos@organizate.rd",
      passwordHash: hash,
      name: "Carlos Martinez",
      rncCedula: "402-9876543-2",
      userType: "INDIVIDUAL",
    },
  });

  const maria = await prisma.user.create({
    data: {
      email: "maria@organizate.rd",
      passwordHash: hash,
      name: "Maria Fernandez",
      rncCedula: "001-5551234-5",
      userType: "PYME",
    },
  });

  console.log("Creando presupuestos...");
  const budgets = await Promise.all([
    // Elena - PYME budgets
    prisma.budget.create({
      data: { userId: elena.id, amount: 250000, spent: 180000, category: "Remodelación Oficina", period: "ANNUAL", budgetType: "PROJECT" },
    }),
    prisma.budget.create({
      data: { userId: elena.id, amount: 150000, spent: 126000, category: "Campaña Marketing Q2", period: "MONTHLY", budgetType: "PROJECT" },
    }),
    prisma.budget.create({
      data: { userId: elena.id, amount: 500000, spent: 0, category: "Lanzamiento Producto", period: "ANNUAL", budgetType: "PROJECT" },
    }),
    prisma.budget.create({
      data: { userId: elena.id, amount: 35000, spent: 28500, category: "Servicios Basicos", period: "MONTHLY", budgetType: "PERSONAL" },
    }),
    prisma.budget.create({
      data: { userId: elena.id, amount: 25000, spent: 17200, category: "Alimentacion", period: "MONTHLY", budgetType: "PERSONAL" },
    }),
    // Carlos - Personal budgets
    prisma.budget.create({
      data: { userId: carlos.id, amount: 15000, spent: 8500, category: "Comida y Supermercado", period: "MONTHLY", budgetType: "PERSONAL" },
    }),
    prisma.budget.create({
      data: { userId: carlos.id, amount: 10000, spent: 7200, category: "Entretenimiento", period: "MONTHLY", budgetType: "PERSONAL" },
    }),
    prisma.budget.create({
      data: { userId: carlos.id, amount: 12000, spent: 11500, category: "Servicios Basicos", period: "MONTHLY", budgetType: "PERSONAL" },
    }),
    // Maria - Projects
    prisma.budget.create({
      data: { userId: maria.id, amount: 800000, spent: 412500, category: "Expansión Regional", period: "ANNUAL", budgetType: "PROJECT" },
    }),
    prisma.budget.create({
      data: { userId: maria.id, amount: 200000, spent: 95000, category: "Sistema ERP", period: "ANNUAL", budgetType: "PROJECT" },
    }),
  ]);

  console.log("Creando metas de ahorro...");
  await Promise.all([
    prisma.goal.create({
      data: { userId: elena.id, name: "Fondo de Emergencia", targetAmount: 500000, currentAmount: 225000, icon: "shield", status: "ACTIVE" },
    }),
    prisma.goal.create({
      data: { userId: elena.id, name: "Vacaciones Punta Cana", targetAmount: 200000, currentAmount: 45000, icon: "flight", status: "ACTIVE" },
    }),
    prisma.goal.create({
      data: { userId: carlos.id, name: "Fondo de Emergencia", targetAmount: 100000, currentAmount: 45000, icon: "shield", status: "ACTIVE" },
    }),
    prisma.goal.create({
      data: { userId: carlos.id, name: "Vacaciones Punta Cana", targetAmount: 150000, currentAmount: 18000, icon: "flight", status: "ACTIVE" },
    }),
    prisma.goal.create({
      data: { userId: maria.id, name: "Inversión Equipamiento", targetAmount: 1000000, currentAmount: 650000, icon: "build", status: "ACTIVE" },
    }),
  ]);

  console.log("Creando transacciones...");
  const now = new Date();
  const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);
  const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);

  await Promise.all([
    // Elena - PYME income & expenses
    prisma.transaction.create({
      data: { userId: elena.id, amount: 850000, type: "INCOME", category: "Ventas", description: "Pago cliente corporativo", date: new Date(thisMonth.getTime() + 1 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: elena.id, amount: 650000, type: "INCOME", category: "Ventas", description: "Servicios consultoria", date: new Date(thisMonth.getTime() + 5 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: elena.id, amount: 45000, type: "EXPENSE", category: "Operacional", description: "Almuerzo cliente", ncf: "B0100001234", date: new Date(thisMonth.getTime() + 2 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: elena.id, amount: 3200, type: "EXPENSE", category: "Transporte", description: "Combustible", ncf: "B0100001235", date: new Date(thisMonth.getTime() + 3 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: elena.id, amount: 15200, type: "EXPENSE", category: "Tecnologia", description: "Licencia software", ncf: "B0100001236", date: new Date(thisMonth.getTime() + 4 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: elena.id, amount: 85000, type: "EXPENSE", category: "Nómina", description: "Pago quincenal equipo", date: new Date(thisMonth.getTime() + 7 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: elena.id, amount: 32400, type: "EXPENSE", category: "Impuestos", description: "ITBIS trimestral", ncf: "B0100001237", date: new Date(thisMonth.getTime() + 10 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: elena.id, amount: 420000, type: "INCOME", category: "Ventas", description: "Consultoria empresarial", date: new Date(lastMonth.getTime() + 10 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: elena.id, amount: 12000, type: "EXPENSE", category: "Marketing", description: "Publicidad redes sociales", ncf: "B0100001200", date: new Date(lastMonth.getTime() + 12 * 86400000) },
    }),
    // Carlos - Personal
    prisma.transaction.create({
      data: { userId: carlos.id, amount: 65000, type: "INCOME", category: "Salario", description: "Salario mensual", date: new Date(thisMonth.getTime() + 1 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: carlos.id, amount: 4500, type: "EXPENSE", category: "Alimentacion", description: "Supermercado", ncf: "B0100002001", date: new Date(thisMonth.getTime() + 3 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: carlos.id, amount: 3200, type: "EXPENSE", category: "Entretenimiento", description: "Cine y cena", ncf: "B0100002002", date: new Date(thisMonth.getTime() + 5 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: carlos.id, amount: 8500, type: "EXPENSE", category: "Servicios", description: "Electricidad y agua", date: new Date(thisMonth.getTime() + 7 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: carlos.id, amount: 15000, type: "INCOME", category: "Freelance", description: "Proyecto web", date: new Date(thisMonth.getTime() + 8 * 86400000) },
    }),
    // Maria - PYME
    prisma.transaction.create({
      data: { userId: maria.id, amount: 2450000, type: "INCOME", category: "Ventas", description: "Ingresos mensuales", date: new Date(thisMonth.getTime() + 1 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: maria.id, amount: 1120400, type: "EXPENSE", category: "Operacional", description: "Gastos operativos", ncf: "B0100003001", date: new Date(thisMonth.getTime() + 5 * 86400000) },
    }),
    prisma.transaction.create({
      data: { userId: maria.id, amount: 180000, type: "EXPENSE", category: "Nómina", description: "Nómina staff", date: new Date(thisMonth.getTime() + 10 * 86400000) },
    }),
  ]);

  console.log("Datos ficticios creados correctamente!");
  console.log("...");
  console.log("Usuarios creados:");
  console.log("  elena@organizate.rd / 123456 (PYME)");
  console.log("  carlos@organizate.rd / 123456 (INDIVIDUAL)");
  console.log("  maria@organizate.rd / 123456 (PYME)");
}

main()
  .catch((e) => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
