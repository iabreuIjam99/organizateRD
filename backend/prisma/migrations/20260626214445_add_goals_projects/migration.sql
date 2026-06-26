-- CreateEnum
CREATE TYPE "BudgetType" AS ENUM ('PERSONAL', 'PROJECT');

-- CreateEnum
CREATE TYPE "GoalStatus" AS ENUM ('ACTIVE', 'COMPLETED', 'PAUSED');

-- AlterTable
ALTER TABLE "budgets" ADD COLUMN     "budget_type" "BudgetType" NOT NULL DEFAULT 'PERSONAL',
ADD COLUMN     "spent" DOUBLE PRECISION NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "goals" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "target_amount" DOUBLE PRECISION NOT NULL,
    "current_amount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "icon" TEXT NOT NULL DEFAULT 'savings',
    "status" "GoalStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "goals_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "goals" ADD CONSTRAINT "goals_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
