@echo off
echo ========================================
echo   OrganizateRD - Deteniendo proyecto...
echo ========================================

echo.
echo [1/2] Deteniendo contenedores Docker...
docker-compose down

echo.
echo [2/2] Cerrando ventanas del proyecto...
taskkill /FI "WINDOWTITLE eq OrganizateRD Backend*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq OrganizateRD Frontend*" /F >nul 2>&1

echo.
echo ========================================
echo   Proyecto detenido correctamente!
echo ========================================
pause
