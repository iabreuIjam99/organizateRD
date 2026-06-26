@echo off
echo ========================================
echo   OrganizateRD - Iniciando proyecto...
echo ========================================

echo.
echo [1/5] Verificando Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker no esta instalado o no esta en el PATH
    pause
    exit /b 1
)

echo.
echo [2/5] Levantando PostgreSQL y pgAdmin...
docker-compose up -d

echo.
echo [3/5] Esperando a que PostgreSQL este listo...
timeout /t 5 /nobreak >nul

echo.
echo [4/5] Ejecutando migraciones y seed de Prisma...
cd backend
call npx prisma generate
call npx prisma migrate deploy
call npm run prisma:seed
cd ..

echo.
echo [5/5] Iniciando Backend y Frontend...
echo.
echo   Backend  -> http://localhost:3000
echo   Frontend -> http://localhost:8080
echo.

start "OrganizateRD Backend" cmd /k "cd backend && npm run dev"
start "OrganizateRD Frontend" cmd /k "cd frontend && flutter run -d chrome --web-port=8080"

echo.
echo ========================================
echo   Proyecto iniciado correctamente!
echo   Backend:  http://localhost:3000/api/health
echo   Frontend: http://localhost:8080
echo ========================================
pause
