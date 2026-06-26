#!/bin/bash
# OrganizateRD - Detener proyecto

echo "Deteniendo Backend y Frontend..."
pkill -f "ts-node-dev" 2>/dev/null || true
pkill -f "flutter run" 2>/dev/null || true

echo "Deteniendo contenedores Docker..."
docker-compose down

echo "Proyecto detenido correctamente!"
