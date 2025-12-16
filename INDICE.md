# 📚 ÍNDICE DE DOCUMENTACIÓN

Guía rápida para navegar toda la documentación del proyecto.

---

## 🎯 DOCUMENTOS PRINCIPALES

### 1. [README.md](./README.md) 📖
**Lo más importante - Lee esto primero**
- Descripción general del proyecto
- Estructura completa
- Arquitectura de la solución
- Requisitos previos
- **Guía paso a paso completa** (FASE 1-7)
- Comandos de prueba
- Troubleshooting
- Costos estimados

**Cuándo usar:** Primera lectura, referencia general, overview del proyecto

---

### 2. [GUIA_EJECUCION.md](./GUIA_EJECUCION.md) 🚀
**Guía detallada de ejecución**
- Checklist pre-ejecución
- 8 fases detalladas con tiempos estimados
- Comandos específicos para cada paso
- Verificaciones en cada fase
- Pruebas avanzadas opcionales
- Procedimiento de limpieza

**Cuándo usar:** Durante la ejecución del proyecto, seguimiento paso a paso

---

### 3. [CHECKLIST.md](./CHECKLIST.md) ✅
**Lista de verificación completa**
- Verificación de estructura de archivos
- Checklist de secretos y credenciales
- Pruebas locales
- Verificaciones de despliegue AWS
- Verificaciones funcionales
- Monitoreo
- Procedimiento de limpieza
- Métricas de éxito
- Objetivos cumplidos

**Cuándo usar:** Verificar que todo esté correcto, troubleshooting, validación final

---

### 4. [ARQUITECTURA.md](./ARQUITECTURA.md) 🏗️
**Arquitectura visual del sistema**
- Vista general del sistema
- Flujo de datos
- Security Groups
- CI/CD Pipeline
- Auto Scaling
- Contenedores en EC2
- Diagrama de red (VPC)
- Stack tecnológico
- Escalabilidad
- Seguridad
- Monitoreo

**Cuándo usar:** Entender la arquitectura, presentaciones, documentación técnica

---

### 5. [COMANDOS.md](./COMANDOS.md) ⚡
**Referencia rápida de comandos**
- Comandos Docker
- Comandos Node.js
- Comandos Git
- AWS CLI
- Terraform
- Testing y debugging
- SSH y conexión a EC2
- Monitoreo
- Limpieza
- Despliegue rápido
- Solución rápida de problemas

**Cuándo usar:** Referencia rápida durante desarrollo, copiar/pegar comandos

---

## 📂 CÓDIGO FUENTE

### BACKEND/
```
├── server.js              # Servidor Express con API REST
├── server.test.js         # Pruebas unitarias (Jest + Supertest)
├── package.json           # Dependencias y scripts
├── jest.config.js         # Configuración de Jest
├── Dockerfile             # Imagen Docker del backend
├── docker-compose.yml     # Compose standalone
├── .dockerignore          # Exclusiones Docker
└── .gitignore             # Exclusiones Git
```

**Endpoints:**
- `GET /health` - Health check
- `GET /api/visitors` - Obtener contador
- `POST /api/visitors/increment` - Incrementar
- `POST /api/visitors/reset` - Reiniciar

---

### FRONTEND/
```
├── public/
│   └── index.html         # Interfaz web del contador
├── nginx.conf             # Nginx + reverse proxy
├── Dockerfile             # Imagen Docker del frontend
├── docker-compose.yml     # Compose frontend + backend
├── .dockerignore          # Exclusiones Docker
└── .gitignore             # Exclusiones Git
```

**Características:**
- Diseño responsive
- Indicador de estado del backend
- Contador en tiempo real
- Proxy reverso a backend

---

### terraform/
```
├── main.tf                # Provider AWS
├── variables.tf           # Variables configurables
├── vpc.tf                 # VPC, subnets, IGW
├── security_groups.tf     # Security Groups
├── load_balancer.tf       # ALB, Target Group
├── autoscaling.tf         # ASG, Launch Template
├── iam.tf                 # Roles IAM
├── outputs.tf             # Outputs
├── user-data.sh           # Script inicialización EC2
├── terraform.tfvars.example
└── .gitignore
```

**Recursos creados:**
- VPC + 2 Subnets públicas
- Load Balancer + Target Group
- Auto Scaling Group (3-4 EC2)
- Security Groups
- CloudWatch Alarms

---

## 🔄 CI/CD

### .github/workflows/
```
├── backend.yml            # Pipeline del backend
└── frontend.yml           # Pipeline del frontend
```

**Backend Pipeline:**
1. Tests unitarios
2. Build Docker
3. Push a DockerHub

**Frontend Pipeline:**
1. Build Docker
2. Push a DockerHub

---

## 🛠️ SCRIPTS AUXILIARES

### deploy.sh (Linux/Mac)
Script Bash para despliegue automatizado:
```bash
./deploy.sh init      # Inicializar Terraform
./deploy.sh plan      # Ver plan
./deploy.sh apply     # Desplegar
./deploy.sh destroy   # Destruir
./deploy.sh output    # Ver outputs
./deploy.sh key       # Crear key pair
```

### deploy.ps1 (Windows)
Script PowerShell para despliegue automatizado:
```powershell
.\deploy.ps1 init      # Inicializar Terraform
.\deploy.ps1 plan      # Ver plan
.\deploy.ps1 apply     # Desplegar
.\deploy.ps1 destroy   # Destruir
.\deploy.ps1 output    # Ver outputs
.\deploy.ps1 key       # Crear key pair
```

---

## 📖 GUÍA DE LECTURA RECOMENDADA

### Para empezar desde cero:
1. **README.md** - Entender el proyecto completo
2. **CHECKLIST.md** - Verificar requisitos previos
3. **GUIA_EJECUCION.md** - Seguir paso a paso
4. **COMANDOS.md** - Tener a mano para copiar comandos

### Para entender la arquitectura:
1. **ARQUITECTURA.md** - Diagramas y explicaciones
2. **README.md** - Sección de arquitectura
3. Código fuente en BACKEND/ y FRONTEND/
4. Terraform en terraform/

### Para troubleshooting:
1. **CHECKLIST.md** - Verificar cada componente
2. **COMANDOS.md** - Sección de solución rápida
3. **README.md** - Sección de troubleshooting
4. Logs en GitHub Actions

### Para presentaciones:
1. **ARQUITECTURA.md** - Diagramas visuales
2. **README.md** - Descripción general
3. **CHECKLIST.md** - Objetivos cumplidos

---

## 🎯 FLUJO DE TRABAJO TÍPICO

### Primera vez:
```
README.md → CHECKLIST.md (verificar requisitos) → 
GUIA_EJECUCION.md (seguir fases) → COMANDOS.md (referencia)
```

### Desarrollo:
```
COMANDOS.md (comandos Docker/Git) → 
CHECKLIST.md (verificar cambios) → 
README.md (troubleshooting si es necesario)
```

### Despliegue AWS:
```
GUIA_EJECUCION.md (Fase 4-5) → 
COMANDOS.md (comandos Terraform/AWS) → 
CHECKLIST.md (verificaciones post-deploy)
```

### Troubleshooting:
```
CHECKLIST.md (identificar problema) → 
COMANDOS.md (comandos de diagnóstico) → 
README.md (soluciones comunes)
```

---

## 📊 ESTADÍSTICAS DEL PROYECTO

### Documentación
- 5 archivos de documentación principales
- 2 scripts de despliegue
- 1 README principal

### Código
- 8 archivos en BACKEND/
- 6 archivos en FRONTEND/
- 11 archivos de Terraform
- 2 workflows de GitHub Actions

### Total
- **35+ archivos**
- **~2000 líneas de código**
- **~5000 líneas de documentación**

---

## 🔗 ENLACES ÚTILES

### Repositorios
- GitHub: https://github.com/Stev97uce/Evaluacion
- DockerHub Backend: https://hub.docker.com/r/stevxd97/visitor-counter-backend
- DockerHub Frontend: https://hub.docker.com/r/stevxd97/visitor-counter-frontend

### Documentación Externa
- Docker: https://docs.docker.com/
- Node.js: https://nodejs.org/docs/
- Express: https://expressjs.com/
- Nginx: https://nginx.org/en/docs/
- Terraform AWS: https://registry.terraform.io/providers/hashicorp/aws/
- GitHub Actions: https://docs.github.com/en/actions

---

## ✨ CARACTERÍSTICAS DESTACADAS

### Desarrollo
- ✅ Separación Front/Back
- ✅ Pruebas unitarias
- ✅ Docker & Docker Compose
- ✅ CI/CD automatizado
- ✅ Health checks

### Infraestructura
- ✅ Alta disponibilidad (multi-AZ)
- ✅ Auto scaling
- ✅ Load balancing
- ✅ Infrastructure as Code
- ✅ Monitoreo con CloudWatch

### Documentación
- ✅ README completo
- ✅ Guía paso a paso
- ✅ Diagramas de arquitectura
- ✅ Checklist de verificación
- ✅ Comandos de referencia

---

## 🎓 CONCEPTOS CUBIERTOS

- Containerización con Docker
- Orquestación con Docker Compose
- CI/CD con GitHub Actions
- Infrastructure as Code (Terraform)
- Cloud Computing (AWS)
- Load Balancing
- Auto Scaling
- Networking (VPC, Subnets, Security Groups)
- Testing (Jest, Supertest)
- Reverse Proxy (Nginx)
- REST APIs
- DevOps practices

---

## 📞 SOPORTE

¿Tienes dudas? Consulta:

1. **README.md** - Sección Troubleshooting
2. **CHECKLIST.md** - Verificación completa
3. **COMANDOS.md** - Solución rápida de problemas
4. Logs en GitHub Actions
5. AWS CloudWatch Logs

---

**¡Proyecto completo y listo para usar!** 🚀

---

## 📋 QUICK START

```bash
# 1. Clonar
git clone https://github.com/Stev97uce/Evaluacion.git
cd Evaluacion

# 2. Leer documentación
cat README.md

# 3. Verificar requisitos
# Ver CHECKLIST.md - Sección "Requisitos"

# 4. Probar localmente
cd FRONTEND
docker-compose up -d

# 5. Desplegar en AWS
cd ../terraform
terraform init
terraform apply

# 6. ¡Disfrutar! 🎉
```

---

**Autor:** Stev97uce  
**Fecha:** Diciembre 2025  
**Versión:** 1.0
