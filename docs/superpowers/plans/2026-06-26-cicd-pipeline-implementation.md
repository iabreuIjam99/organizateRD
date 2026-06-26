# Pipeline CI/CD con Seguridad - Plan de Implementación

> **Para trabajadores agénticos:** HABILIDADES SUB-REQUERIDAS: Usar superpowers:subagent-driven-development (recomendado) o superpowers:executing-plans para implementar este plan tarea por tarea. Los pasos usan sintaxis de casillas de verificación (`- [ ]`) para seguimiento.

**Objetivo:** Crear pipeline GitHub Actions que valide commits con IA para mejorar seguridad.

**Arquitectura:** GitHub Actions + ESLint/Flutter Analyzer + SonarQube + Snyk + OpenAI API

**Tech Stack:** GitHub Actions, Node.js, Flutter, OpenAI

---

### Task 1: Configurar Gitignore y Estructura

**Archivos:**
- Modificar: `.gitignore`
- Crear: `.github/workflows/ci.yml`
- Crear: `.github/workflows/security-scan.yml`
- Crear: `.github/workflows/ai-review.yml`

- [ ] **Paso 1: Actualizar .gitignore**

```gitignore
# Archivos de entorno
.env
.env.local
.env.*.local

# Archivos de secretos
*.key
*.pem
*.p12
secrets/
credentials/

# Dependencias
node_modules/
flutter/.dart_tool/
flutter/.packages
flutter/build/
flutter/.pub-cache/
flutter/.pub/

# Build artifacts
dist/
build/
*.log
```

- [ ] **Paso 2: Crear estructura de directorios**

```bash
mkdir -p .github/workflows
mkdir -p scripts
```

- [ ] **Paso 3: Commit inicial**

```bash
git add .gitignore
git commit -m "chore: add gitignore rules for security"
```

---

### Task 2: Pipeline Principal CI

**Archivos:**
- Crear: `.github/workflows/ci.yml`

- [ ] **Paso 1: Crear workflow de CI principal**

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    name: Code Quality
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Install Backend Dependencies
        run: npm ci
        working-directory: backend
        
      - name: Run ESLint
        run: npm run lint
        working-directory: backend
        
      - name: TypeScript Check
        run: npx tsc --noEmit
        working-directory: backend

  flutter-analyze:
    name: Flutter Analysis
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          
      - name: Install Dependencies
        run: flutter pub get
        working-directory: frontend
        
      - name: Flutter Analyze
        run: flutter analyze
        working-directory: frontend

  test-backend:
    name: Backend Tests
    runs-on: ubuntu-latest
    needs: lint
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: organizaterd
          POSTGRES_PASSWORD: test_password
          POSTGRES_DB: organizaterd_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
          
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Install Dependencies
        run: npm ci
        working-directory: backend
        
      - name: Generate Prisma Client
        run: npx prisma generate
        working-directory: backend
        
      - name: Run Migrations
        run: npx prisma migrate deploy
        working-directory: backend
        env:
          DATABASE_URL: postgresql://organizaterd:test_password@localhost:5432/organizaterd_test
          
      - name: Run Tests
        run: npm test
        working-directory: backend
        env:
          DATABASE_URL: postgresql://organizaterd:test_password@localhost:5432/organizaterd_test
          JWT_SECRET: test_secret_key
```

- [ ] **Paso 2: Commit del workflow CI**

```bash
git add .github/workflows/ci.yml
git commit -m "ci: add main CI pipeline with linting and tests"
```

---

### Task 3: Pipeline de Seguridad

**Archivos:**
- Crear: `.github/workflows/security-scan.yml`

- [ ] **Paso 1: Crear workflow de escaneo de seguridad**

```yaml
# .github/workflows/security-scan.yml
name: Security Scan

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 12 * * 1'  # Lunes a las 12pm

jobs:
  snyk:
    name: Vulnerability Scan
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Snyk to check for vulnerabilities
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --all-projects
          
  codeql:
    name: CodeQL Analysis
    uses: github/codeql-action/init@v3
    with:
      languages: javascript,typescript
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      
  secret-scan:
    name: Secret Detection
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Scan for secrets
        uses: trufflesecurity/trufflehog@main
        with:
          extra_args: --only-verified
```

- [ ] **Paso 2: Commit del workflow de seguridad**

```bash
git add .github/workflows/security-scan.yml
git commit -m "ci: add security scanning pipeline"
```

---

### Task 4: Asistente de Revisión IA

**Archivos:**
- Crear: `.github/workflows/ai-review.yml`
- Crear: `scripts/ai-security-analysis.js`

- [ ] **Paso 1: Crear script de análisis IA**

```javascript
// scripts/ai-security-analysis.js
const { execSync } = require('child_process');
const OpenAI = require('openai');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

async function analyzeChanges() {
  try {
    // Obtener diff de cambios
    const diff = execSync('git diff HEAD~1 --stat').toString();
    const filesChanged = execSync('git diff HEAD~1 --name-only').toString();
    
    // Preparar prompt para análisis de seguridad
    const prompt = `
      Analiza los siguientes cambios de código para una aplicación financiera:
      
      Archivos modificados:
      ${filesChanged}
      
      Resumen de cambios:
      ${diff}
      
      Proporciona:
      1. Nivel de riesgo (0-100)
      2. Problemas de seguridad potenciales
      3. Recomendaciones específicas
      4. Confianza en el análisis (0-100%)
    `;

    const completion = await openai.chat.completions.create({
      model: "gpt-4",
      messages: [{ role: "user", content: prompt }],
      max_tokens: 1000
    });

    const analysis = completion.choices[0].message.content;
    
    // Extraer confianza del análisis
    const confidenceMatch = analysis.match(/Confianza:.*?(\d+)%/);
    const confidence = confidenceMatch ? parseInt(confidenceMatch[1]) : 0;
    
    console.log('Análisis de Seguridad IA:');
    console.log(analysis);
    console.log(`\nConfianza: ${confidence}%`);
    
    // Salir con código de error si confianza < 80%
    if (confidence < 80) {
      console.log('\n⚠️  Confianza baja - Se requiere revisión manual');
      process.exit(1);
    }
    
  } catch (error) {
    console.error('Error en análisis IA:', error);
    process.exit(1);
  }
}

analyzeChanges();
```

- [ ] **Paso 2: Crear workflow de revisión IA**

```yaml
# .github/workflows/ai-review.yml
name: AI Security Review

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  ai-analysis:
    name: AI Security Analysis
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 2
          
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Install Dependencies
        run: npm ci
        
      - name: Run AI Security Analysis
        run: node scripts/ai-security-analysis.js
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
          
      - name: Comment on PR
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const analysis = fs.readFileSync('analysis.txt', 'utf8');
            
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 🤖 Análisis de Seguridad IA\n\n${analysis}`
            });
```

- [ ] **Paso 3: Commit del workflow de IA**

```bash
git add .github/workflows/ai-review.yml scripts/ai-security-analysis.js
git commit -m "ci: add AI security review pipeline"
```

---

### Task 5: Gestión de Dependencias

**Archivos:**
- Crear: `.github/dependabot.yml`

- [ ] **Paso 1: Configurar Dependabot**

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/backend"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    labels:
      - "dependencies"
      - "security"
      
  - package-ecosystem: "pub"
    directory: "/frontend"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    labels:
      - "dependencies"
      - "flutter"
```

- [ ] **Paso 2: Commit de Dependabot**

```bash
git add .github/dependabot.yml
git commit -m "ci: add dependabot for dependency updates"
```

---

### Task 6: Plantilla de Variables de Entorno

**Archivos:**
- Crear: `.env.example`

- [ ] **Paso 1: Crear plantilla .env.example**

```bash
# Base de datos
DATABASE_URL=postgresql://user:password@localhost:5432/organizaterd_db

# JWT
JWT_SECRET=tu_secreto_jwt_aqui
JWT_EXPIRES_IN=7d

# Puerto del servidor
PORT=3000

# OpenAI (para análisis de seguridad)
OPENAI_API_KEY=tu_api_key_openai

# Discord Webhook (notificaciones)
DISCORD_WEBHOOK=tu_webhook_discord

# Snyk
SNYK_TOKEN=tu_token_snyk
```

- [ ] **Paso 2: Commit de .env.example**

```bash
git add .env.example
git commit -m "chore: add environment variable template"
```

---

### Task 7: Documentación de Seguridad

**Archivos:**
- Crear: `SECURITY.md`

- [ ] **Paso 1: Crear documentación de seguridad**

```markdown
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
```

- [ ] **Paso 2: Commit de SECURITY.md**

```bash
git add SECURITY.md
git commit -m "docs: add security policy documentation"
```

---

### Task 8: Verificación Final

- [ ] **Paso 1: Verificar que todos los workflows están correctos**

```bash
# Verificar estructura
ls -la .github/workflows/
ls -la scripts/
cat .github/workflows/ci.yml
cat .github/workflows/security-scan.yml
cat .github/workflows/ai-review.yml
```

- [ ] **Paso 2: Probar workflows localmente (opcional)**

```bash
# Instalar act (GitHub Actions local runner)
brew install act  # macOS
# o
choco install act  # Windows

# Ejecutar CI localmente
act -j lint
```

- [ ] **Paso 3: Commit final y push**

```bash
git add .
git commit -m "ci: complete CI/CD pipeline with security validation"
git push origin main
```

---

## Verificación de Implementación

Después de implementar, verificar:

1. ✅ GitHub Actions se ejecutan en cada push
2. ✅ Linting pasa sin errores
3. ✅ Tests se ejecutan correctamente
4. ✅ Escaneo de seguridad detecta vulnerabilidades
5. ✅ Análisis IA proporciona feedback
6. ✅ Dependabot crea PRs para actualizaciones

## Notas de Implementación

- **Secrets requeridos en GitHub:**
  - `OPENAI_API_KEY`: Para análisis de IA
  - `SNYK_TOKEN`: Para escaneo de vulnerabilidades
  - `DATABASE_URL`: Para tests
  - `JWT_SECRET`: Para tests

- **Archivos críticos:** Requieren aprobación manual antes de merge

- **Confianza IA:** Si es <80%, se solicita revisión manual automáticamente

---

> **Plan completo.** Ejecutar con subagent-driven-development o executing-plans.
