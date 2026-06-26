#!/bin/bash
# OrganizateRD - Script de inicio completo

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  OrganizateRD - Iniciando proyecto...${NC}"
echo -e "${CYAN}========================================${NC}"

# 1. Verificar Docker
echo -e "\n${GREEN}[1/5] Verificando Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}ERROR: Docker no esta instalado${NC}"
    exit 1
fi

# 2. Levantar contenedores
echo -e "\n${GREEN}[2/5] Levantando PostgreSQL y pgAdmin...${NC}"
docker-compose up -d

# 3. Esperar PostgreSQL
echo -e "\n${GREEN}[3/5] Esperando a que PostgreSQL este listo...${NC}"
sleep 5

# 4. Migraciones
echo -e "\n${GREEN}[4/5] Ejecutando migraciones y seed de Prisma...${NC}"
cd backend
npx prisma generate
npx prisma migrate deploy
npm run prisma:seed
cd ..

# 5. Iniciar servicios
echo -e "\n${GREEN}[5/5] Iniciando Backend y Frontend...${NC}"
echo -e "  Backend  -> http://localhost:3000"
echo -e "  Frontend -> http://localhost:8080"

# Iniciar backend en background
cd backend
npm run dev &
BACKEND_PID=$!
cd ..

# Iniciar frontend
cd frontend
flutter run -d chrome --web-port=8080 &
FRONTEND_PID=$!
cd ..

echo -e "\n${CYAN}========================================${NC}"
echo -e "${GREEN}  Proyecto iniciado correctamente!${NC}"
echo -e "${CYAN}  Backend:  http://localhost:3000/api/health${NC}"
echo -e "${CYAN}  Frontend: http://localhost:8080${NC}"
echo -e "${CYAN}========================================${NC}"

# Trap para cleanup
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; docker-compose down" EXIT

wait
