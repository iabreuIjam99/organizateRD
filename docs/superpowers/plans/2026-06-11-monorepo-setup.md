# OrganizateRD Monorepo Setup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Set up a complete monorepo for OrganizateRD - a budget management application for individuals and Mipymes in the Dominican Republic.

**Architecture:** Monorepo with Docker Compose for local PostgreSQL/pgAdmin, Node.js/Express/Prisma backend in TypeScript, and Flutter frontend with Clean Architecture (Data/Domain/Presentation layers).

**Tech Stack:** Node.js 18+, TypeScript, Express, Prisma ORM, PostgreSQL, Flutter, flutter_bloc, Dio, Docker Compose, VS Code

---

## Files Created

| File | Purpose |
|------|---------|
| `docker-compose.yml` | PostgreSQL 15-alpine + pgAdmin4 containers |
| `backend/package.json` | Node.js deps: express, cors, jwt, bcrypt, prisma, typescript |
| `backend/tsconfig.json` | TypeScript config targeting ES2022 |
| `backend/.env.example` | Environment template (DB URL, JWT secret, port) |
| `backend/prisma/schema.prisma` | User, Budget, Transaction models with enums |
| `backend/src/app.ts` | Express server with /api/health endpoint |
| `frontend/pubspec.yaml` | Flutter deps: flutter_bloc, dio, shared_preferences, intl, equatable |
| `frontend/lib/main.dart` | App entry point with Material theme and WelcomePage |
| `frontend/lib/core/constants/constants.dart` | App constants (base URL, currency DOP) |
| `frontend/lib/core/network/api_client.dart` | Dio HTTP client with interceptors |
| `frontend/lib/core/theme/theme.dart` | Material 3 theme with green primary |
| `frontend/lib/features/*/presentation/pages/*.dart` | Placeholder pages for auth, budget, taxes |
| `.vscode/launch.json` | Debug configs: Backend, Flutter Web, Flutter Emulator, Full Stack compound |
| `.vscode/settings.json` | formatOnSave, Prettier for TS, Dart formatter |
| `.gitignore` | Root + backend + frontend git ignores |
