# 🚀 INSTRUCCIONES PARA SUBIR A GITHUB

Guía paso a paso para subir el proyecto al repositorio de GitHub.

---

## 📋 PRE-REQUISITOS

- [x] Git instalado
- [x] Cuenta de GitHub (Stev97uce)
- [x] Repositorio creado: https://github.com/Stev97uce/Evaluacion.git

---

## 🔧 PASO 1: Configurar Git (Si es necesario)

```powershell
# Configurar usuario
git config --global user.name "Stev97uce"
git config --global user.email "tu-email@ejemplo.com"

# Verificar configuración
git config --list
```

---

## 📦 PASO 2: Inicializar Repositorio Local

```powershell
# Navegar al directorio del proyecto
cd 'c:\Users\Stev\Desktop\Stev\U\Noveno\Distribuida 2.0\Correccion de la evaluacion'

# Inicializar git (si no está inicializado)
git init

# Verificar estado
git status
```

---

## 🔗 PASO 3: Conectar con GitHub

```powershell
# Agregar remote (si no existe)
git remote add origin https://github.com/Stev97uce/Evaluacion.git

# Verificar remote
git remote -v
```

**Nota**: Si ya existe el remote, puedes actualizarlo:
```powershell
git remote set-url origin https://github.com/Stev97uce/Evaluacion.git
```

---

## 📝 PASO 4: Preparar Archivos

```powershell
# Ver archivos que se subirán
git status

# Agregar todos los archivos
git add .

# Ver archivos staged
git status
```

**Verificación**: Asegúrate que NO se incluyan:
- ❌ node_modules/
- ❌ .terraform/
- ❌ *.tfstate
- ❌ *.log
- ❌ .env

El `.gitignore` ya está configurado para excluir estos archivos.

---

## 💾 PASO 5: Hacer Commit

```powershell
# Commit inicial
git commit -m "feat: Initial commit - Visitor Counter Full Stack Application

- Backend API con Node.js + Express
- Frontend con HTML + Nginx
- Docker & Docker Compose
- CI/CD con GitHub Actions
- Infraestructura AWS con Terraform
- Documentación completa
- Auto Scaling y Load Balancing configurados"

# Verificar commit
git log --oneline
```

---

## 🚀 PASO 6: Subir a GitHub

### Opción A: Primera vez (crear rama main)

```powershell
# Renombrar rama a main (si es master)
git branch -M main

# Push inicial
git push -u origin main
```

### Opción B: Si el repo ya existe con contenido

```powershell
# Pull primero para evitar conflictos
git pull origin main --allow-unrelated-histories

# Resolver conflictos si los hay
# Luego push
git push origin main
```

### Opción C: Forzar push (usar solo si estás seguro)

```powershell
# ⚠️ CUIDADO: Esto sobrescribe el repositorio remoto
git push -f origin main
```

---

## ✅ PASO 7: Verificar en GitHub

1. Ir a: https://github.com/Stev97uce/Evaluacion
2. Verificar que todos los archivos estén presentes:
   - ✅ README.md
   - ✅ BACKEND/
   - ✅ FRONTEND/
   - ✅ terraform/
   - ✅ .github/workflows/
   - ✅ Archivos de documentación

---

## 🔐 PASO 8: Configurar Secrets en GitHub

**IMPORTANTE**: Para que GitHub Actions funcione correctamente.

1. Ir a: https://github.com/Stev97uce/Evaluacion/settings/secrets/actions
2. Click en **New repository secret**
3. Crear los siguientes secretos:

### Secret 1: DOCKERHUB_USERNAME
```
Nombre: DOCKERHUB_USERNAME
Valor:  stevxd97
```
Click en **Add secret**

### Secret 2: DOCKERHUB_TOKEN
```
Nombre: DOCKERHUB_TOKEN
Valor:  [TU_DOCKERHUB_TOKEN]
```
Click en **Add secret**

### Verificar Secrets
Deberías ver:
- ✅ DOCKERHUB_USERNAME
- ✅ DOCKERHUB_TOKEN

---

## 🔄 PASO 9: Verificar GitHub Actions

1. Ir a: https://github.com/Stev97uce/Evaluacion/actions
2. Deberías ver workflows ejecutándose:
   - Backend CI/CD
   - Frontend CI/CD

**Si no se ejecutan automáticamente**, haz un pequeño cambio:

```powershell
# Crear un commit vacío para activar workflows
git commit --allow-empty -m "chore: trigger CI/CD"
git push origin main
```

### Verificar que los Workflows completen exitosamente:

**Backend CI/CD debe:**
- ✅ Checkout code
- ✅ Setup Node.js
- ✅ Install dependencies
- ✅ Run tests
- ✅ Build Docker image
- ✅ Push to DockerHub

**Frontend CI/CD debe:**
- ✅ Checkout code
- ✅ Setup Docker Buildx
- ✅ Build Docker image
- ✅ Push to DockerHub

---

## 🐳 PASO 10: Verificar DockerHub

1. Ir a: https://hub.docker.com/u/stevxd97
2. Verificar que existan dos repositorios:
   - ✅ stevxd97/visitor-counter-backend
   - ✅ stevxd97/visitor-counter-frontend
3. Cada uno debe tener al menos un tag:
   - latest
   - main-[sha]

---

## 📊 PASO 11: Verificación Final

### En GitHub
```powershell
# Ver commits
git log --oneline -5

# Ver archivos trackeados
git ls-files
```

### Checklist Final
- [x] Código subido a GitHub
- [x] Todos los archivos presentes
- [x] .gitignore funcionando correctamente
- [x] Secrets configurados en GitHub
- [x] GitHub Actions ejecutándose
- [x] Tests pasando en CI
- [x] Imágenes en DockerHub

---

## 🔄 ACTUALIZACIONES FUTURAS

Cuando hagas cambios:

```powershell
# 1. Hacer cambios en el código
# 2. Ver cambios
git status
git diff

# 3. Agregar cambios
git add .

# 4. Commit
git commit -m "descripción del cambio"

# 5. Push
git push origin main

# GitHub Actions se ejecutará automáticamente
```

---

## 🆘 TROUBLESHOOTING

### Error: "failed to push some refs"

**Solución**:
```powershell
git pull origin main --rebase
git push origin main
```

### Error: "Authentication failed"

**Solución**:
```powershell
# Usar Personal Access Token en lugar de password
# Ir a: GitHub → Settings → Developer settings → Personal access tokens
# Generar nuevo token con permisos de repo
```

### Error: GitHub Actions no se ejecuta

**Soluciones**:
1. Verificar que los workflows estén en `.github/workflows/`
2. Verificar sintaxis YAML
3. Hacer un commit para activarlos:
```powershell
git commit --allow-empty -m "chore: trigger CI/CD"
git push origin main
```

### Error: DockerHub login failed en GitHub Actions

**Soluciones**:
1. Verificar que los secrets estén correctamente configurados
2. Verificar que el token de DockerHub sea válido
3. Regenerar token en DockerHub si es necesario

---

## 📚 COMANDOS ÚTILES

### Ver historial
```powershell
git log --oneline --graph --all
```

### Ver diferencias
```powershell
git diff HEAD~1
```

### Ver archivos ignorados
```powershell
git status --ignored
```

### Ver tamaño del repositorio
```powershell
git count-objects -vH
```

### Limpiar archivos no trackeados
```powershell
git clean -fd -n  # Ver qué se eliminará
git clean -fd     # Eliminar
```

---

## 🎯 ESTRUCTURA EN GITHUB

Una vez subido, tu repositorio debe verse así:

```
Stev97uce/Evaluacion
├── .github/
│   └── workflows/
│       ├── backend.yml
│       └── frontend.yml
├── BACKEND/
│   ├── server.js
│   ├── server.test.js
│   ├── package.json
│   ├── Dockerfile
│   └── ...
├── FRONTEND/
│   ├── public/
│   ├── nginx.conf
│   ├── Dockerfile
│   └── ...
├── terraform/
│   ├── main.tf
│   ├── vpc.tf
│   └── ...
├── README.md
├── GUIA_EJECUCION.md
├── CHECKLIST.md
├── ARQUITECTURA.md
├── COMANDOS.md
├── INDICE.md
├── RESUMEN.md
├── .gitignore
├── deploy.sh
└── deploy.ps1
```

---

## ✅ CHECKLIST COMPLETO

- [ ] Git configurado localmente
- [ ] Repositorio inicializado
- [ ] Remote agregado
- [ ] Archivos agregados (git add)
- [ ] Commit realizado
- [ ] Push a GitHub exitoso
- [ ] Archivos visibles en GitHub
- [ ] Secrets configurados
- [ ] GitHub Actions ejecutándose
- [ ] Tests pasando en CI
- [ ] Imágenes en DockerHub
- [ ] README visible en GitHub

---

## 🎉 ¡LISTO!

Una vez completados todos los pasos, tu proyecto estará:

✅ En GitHub con todo el código  
✅ Con CI/CD funcionando  
✅ Con imágenes en DockerHub  
✅ Listo para desplegar en AWS  
✅ Documentado completamente  

---

## 📞 SIGUIENTE PASO

Después de subir a GitHub, proceder con el despliegue en AWS siguiendo la **GUIA_EJECUCION.md** - Fase 4.

---

**¡Éxito con tu proyecto!** 🚀
