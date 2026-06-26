# Seguridad - OrganizateRD

## Política de Seguridad

### Autenticación
- JWT con expiración de 7 días
- Tokens almacenados en SharedPreferences (mobile) o cookies HttpOnly (web)
- Headers de autorización Bearer en todas las requests

### Datos Sensibles
- Contraseñas hasheadas con bcrypt (10 rounds)
- Secrets en variables de entorno, nunca en código
- Base de datos con acceso restringido por IP

### CI/CD Security
- Branches protegidos en `main`
- Revisión manual requerida para archivos críticos
- Escaneo automático de vulnerabilidades
- Análisis de IA para detección de riesgos

### Archivos Críticos (Requieren Aprobación)
- `backend/src/middlewares/auth.middleware.ts`
- `backend/src/utils/prisma.ts`
- `frontend/lib/core/network/api_client.dart`

## Reportar Vulnerabilidades

Si encuentras una vulnerabilidad, por favor repórtala a:
- Email: security@organizate.rd
- GitHub: Crear issue con label `security`

## Checklist de Seguridad

- [ ] Variables de entorno no están en el repositorio
- [ ] Contraseñas están hasheadas
- [ ] JWT tiene expiración configurada
- [ ] CORS está configurado correctamente
- [ ] Rate limiting está habilitado
- [ ] Logs no contienen datos sensibles
