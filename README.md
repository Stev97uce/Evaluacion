# 🚀 Práctica Full Stack: Contador de Visitas con Docker, GitHub Actions y AWS

## 📋 Descripción del Proyecto

Aplicación web full stack que implementa un contador de visitas con:
- **Backend**: Node.js + Express (API REST)
- **Frontend**: HTML + CSS + JavaScript + Nginx
- **Containerización**: Docker & Docker Compose
- **CI/CD**: GitHub Actions (pruebas unitarias + push a DockerHub)
- **Infraestructura**: AWS (ALB + Auto Scaling Group + EC2 t3.micro)

---

## 📁 Estructura del Proyecto

```
.
├── BACKEND/                    # Backend API (Node.js + Express)
│   ├── server.js              # Servidor principal
│   ├── server.test.js         # Pruebas unitarias
│   ├── package.json           # Dependencias Node.js
│   ├── Dockerfile             # Imagen Docker del backend
│   ├── docker-compose.yml     # Compose para backend standalone
│   └── jest.config.js         # Configuración de Jest
│
├── FRONTEND/                   # Frontend web (HTML + Nginx)
│   ├── public/
│   │   └── index.html         # Interfaz web del contador
│   ├── nginx.conf             # Configuración Nginx + reverse proxy
│   ├── Dockerfile             # Imagen Docker del frontend
│   └── docker-compose.yml     # Compose para frontend + backend
│
├── terraform/                  # Infraestructura como código (AWS)
│   ├── main.tf                # Configuración principal de Terraform
│   ├── variables.tf           # Variables configurables
│   ├── vpc.tf                 # VPC, subnets, internet gateway
│   ├── security_groups.tf     # Security groups (ALB y EC2)
│   ├── load_balancer.tf       # Application Load Balancer
│   ├── autoscaling.tf         # Auto Scaling Group + políticas
│   ├── iam.tf                 # Roles y políticas IAM
│   ├── outputs.tf             # Outputs de Terraform
│   ├── user-data.sh           # Script de inicialización EC2
│   └── terraform.tfvars.example
│
├── .github/
│   └── workflows/
│       ├── backend.yml        # CI/CD Pipeline del backend
│       └── frontend.yml       # CI/CD Pipeline del frontend
│
└── README.md                  # Este archivo
```

---

## 🎯 Arquitectura de la Solución

```
┌─────────────┐
│   Usuario   │
└──────┬──────┘
       │ HTTP
       ▼
┌──────────────────────────┐
│  Application Load        │
│  Balancer (ALB)          │
└──────┬───────────────────┘
       │
       ├─────────┬─────────┬─────────┐
       ▼         ▼         ▼         ▼
    ┌────┐   ┌────┐   ┌────┐   ┌────┐
    │EC2 │   │EC2 │   │EC2 │   │EC2 │  Auto Scaling Group
    │t3  │   │t3  │   │t3  │   │t3  │  (3-4 instancias)
    └─┬──┘   └─┬──┘   └─┬──┘   └─┬──┘
      │        │        │        │
      └────────┴────────┴────────┘
               │
        ┌──────▼──────────┐
        │  Docker Compose │
        │  ┌────────────┐ │
        │  │ Frontend   │ │  Nginx :80
        │  │ Container  │ │
        │  └──────┬─────┘ │
        │         │        │
        │  ┌──────▼─────┐ │
        │  │  Backend   │ │  Node.js :3000
        │  │  Container │ │
        │  └────────────┘ │
        └─────────────────┘
```

---

## 🔧 Requisitos Previos

### Software Necesario:
- Git
- Docker Desktop
- Node.js v18+ (para desarrollo local)
- Terraform v1.0+ (para infraestructura AWS)
- Cuenta de GitHub
- Cuenta de DockerHub
- Cuenta de AWS con credenciales configuradas

### Credenciales Requeridas:
- GitHub: `Stev97uce`
- DockerHub: `stevxd97`
- Token DockerHub: `[TU_DOCKERHUB_TOKEN]` (generar en https://hub.docker.com/settings/security)

---

## 📝 GUÍA PASO A PASO - EJECUCIÓN COMPLETA

### **FASE 1: PREPARACIÓN DEL REPOSITORIO**

#### Paso 1.1: Clonar y Preparar el Repositorio

```bash
# Clonar el repositorio
git clone https://github.com/Stev97uce/Evaluacion.git
cd Evaluacion

# Verificar estructura
dir
```

#### Paso 1.2: Configurar Git (si es necesario)

```bash
git config user.name "Stev97uce"
git config user.email "tu-email@ejemplo.com"
```

---

### **FASE 2: DESARROLLO Y PRUEBAS LOCALES**

#### Paso 2.1: Probar Backend Localmente

```bash
cd BACKEND

# Instalar dependencias
npm install

# Ejecutar pruebas unitarias
npm test

# Levantar servidor en modo desarrollo
npm run dev
# El backend estará en http://localhost:3000
```

**Endpoints disponibles:**
- `GET /health` - Health check
- `GET /api/visitors` - Obtener contador
- `POST /api/visitors/increment` - Incrementar contador
- `POST /api/visitors/reset` - Resetear contador

#### Paso 2.2: Probar con Docker (Backend)

```bash
# Construir imagen
docker build -t stevxd97/visitor-counter-backend:latest .

# Ejecutar contenedor
docker run -d -p 3000:3000 --name test-backend stevxd97/visitor-counter-backend:latest

# Verificar logs
docker logs test-backend

# Probar endpoint
curl http://localhost:3000/health

# Detener y limpiar
docker stop test-backend
docker rm test-backend
```

#### Paso 2.3: Probar Frontend con Docker Compose

```bash
cd ../FRONTEND

# Levantar toda la aplicación (frontend + backend)
docker-compose up -d

# Ver logs
docker-compose logs -f

# Abrir navegador en: http://localhost
# La aplicación debería mostrarse completamente funcional

# Detener
docker-compose down
```

---

### **FASE 3: CONFIGURACIÓN DE GITHUB Y GITHUB ACTIONS**

#### Paso 3.1: Crear Secretos en GitHub

1. Ve a tu repositorio: https://github.com/Stev97uce/Evaluacion
2. Click en **Settings** → **Secrets and variables** → **Actions**
3. Click en **New repository secret**
4. Crear los siguientes secretos:

```
Nombre: DOCKERHUB_USERNAME
Valor: stevxd97

Nombre: DOCKERHUB_TOKEN
Valor: [TU_DOCKERHUB_TOKEN]
```

#### Paso 3.2: Subir Código a GitHub

```bash
# Volver al directorio raíz del proyecto
cd ..

# Agregar todos los archivos
git add .

# Hacer commit
git commit -m "Initial commit: Visitor Counter Full Stack App"

# Subir a GitHub
git push origin main
```

**Nota**: Si tu rama principal es `master` en lugar de `main`, usa:
```bash
git push origin master
```

#### Paso 3.3: Verificar GitHub Actions

1. Ve a tu repositorio en GitHub
2. Click en la pestaña **Actions**
3. Deberías ver dos workflows ejecutándose:
   - `Backend CI/CD`
   - `Frontend CI/CD`

4. El workflow de Backend hará:
   - ✅ Ejecutar pruebas unitarias
   - ✅ Construir imagen Docker
   - ✅ Subir imagen a DockerHub

5. El workflow de Frontend hará:
   - ✅ Construir imagen Docker
   - ✅ Subir imagen a DockerHub

#### Paso 3.4: Verificar Imágenes en DockerHub

1. Ve a: https://hub.docker.com/u/stevxd97
2. Deberías ver dos repositorios:
   - `stevxd97/visitor-counter-backend`
   - `stevxd97/visitor-counter-frontend`

---

### **FASE 4: DESPLIEGUE EN AWS CON TERRAFORM**

#### Paso 4.1: Configurar AWS CLI

```bash
# Instalar AWS CLI (si no está instalado)
# Windows: descargar de https://aws.amazon.com/cli/

# Configurar credenciales
aws configure
# AWS Access Key ID: [TU_ACCESS_KEY]
# AWS Secret Access Key: [TU_SECRET_KEY]
# Default region name: us-east-1
# Default output format: json
```

#### Paso 4.2: Crear Key Pair para EC2

```bash
# Crear key pair en AWS
aws ec2 create-key-pair --key-name visitor-counter-key --query 'KeyMaterial' --output text > visitor-counter-key.pem

# En Windows PowerShell, guardar el archivo correctamente
```

**Alternativa (desde la consola AWS):**
1. Ve a EC2 → Key Pairs
2. Create Key Pair
3. Nombre: `visitor-counter-key`
4. Type: RSA
5. Format: .pem
6. Descargar y guardar el archivo

#### Paso 4.3: Configurar Variables de Terraform

```bash
cd terraform

# Copiar archivo de ejemplo
copy terraform.tfvars.example terraform.tfvars

# Editar terraform.tfvars si necesitas cambiar algún valor
# Por defecto ya está configurado correctamente
```

#### Paso 4.4: Inicializar y Aplicar Terraform

```bash
# Inicializar Terraform
terraform init

# Ver plan de ejecución
terraform plan

# Aplicar infraestructura (ESTO CREARÁ RECURSOS EN AWS)
terraform apply

# Escribir 'yes' cuando se solicite confirmación
```

**⏳ IMPORTANTE**: Este proceso tomará aproximadamente **5-10 minutos**.

Terraform creará:
- ✅ 1 VPC con 2 subnets públicas
- ✅ 1 Internet Gateway
- ✅ 2 Security Groups (ALB y EC2)
- ✅ 1 Application Load Balancer
- ✅ 1 Target Group
- ✅ 1 Launch Template
- ✅ 1 Auto Scaling Group (con 3-4 instancias EC2 t3.micro)
- ✅ Roles y políticas IAM
- ✅ CloudWatch Alarms

#### Paso 4.5: Obtener URL de la Aplicación

```bash
# Ver outputs de Terraform
terraform output

# Copiar el load_balancer_url
# Ejemplo: http://visitor-counter-alb-123456789.us-east-1.elb.amazonaws.com
```

#### Paso 4.6: Esperar Inicialización de Instancias

Las instancias EC2 tardan aproximadamente **3-5 minutos** adicionales en:
1. Instalar Docker
2. Instalar Docker Compose
3. Descargar imágenes de DockerHub
4. Levantar contenedores

**Verificar estado:**
```bash
# Ver instancias en Auto Scaling Group
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names visitor-counter-asg

# Ver instancias EC2
aws ec2 describe-instances --filters "Name=tag:Name,Values=visitor-counter-asg-instance" --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' --output table
```

#### Paso 4.7: Acceder a la Aplicación

1. Abre tu navegador
2. Ve a la URL del Load Balancer (obtenida en Paso 4.5)
3. ¡Deberías ver la aplicación funcionando! 🎉

---

### **FASE 5: PRUEBAS Y VERIFICACIÓN**

#### Paso 5.1: Probar Funcionalidad

1. **Verificar contador inicial**: Debería mostrar 0
2. **Click en "Incrementar"**: El contador debe aumentar
3. **Refrescar página**: El contador mantiene el valor
4. **Click en "Reiniciar"**: El contador vuelve a 0

#### Paso 5.2: Verificar Load Balancing

```bash
# Hacer múltiples requests
for ($i=1; $i -le 10; $i++) { curl http://[LOAD_BALANCER_URL]/api/visitors }

# Deberías ver respuestas de diferentes instancias
```

#### Paso 5.3: Probar Auto Scaling

```bash
# Ver instancias actuales
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names visitor-counter-asg --query 'AutoScalingGroups[0].Instances[*].[InstanceId,HealthStatus,LifecycleState]' --output table

# Simular alta carga (opcional)
# Esto eventualmente activará el scale-up si el CPU > 70%
```

#### Paso 5.4: Ver Logs de Contenedores en EC2

```bash
# Conectar a una instancia EC2 (reemplazar con tu IP pública)
ssh -i visitor-counter-key.pem ec2-user@[EC2_PUBLIC_IP]

# Una vez conectado:
cd ~
sudo docker-compose ps
sudo docker-compose logs

# Salir
exit
```

---

### **FASE 6: MONITOREO Y MANTENIMIENTO**

#### Paso 6.1: CloudWatch Dashboards

1. Ve a AWS Console → CloudWatch
2. Selecciona Dashboards
3. Verás métricas de:
   - CPU utilization
   - Network in/out
   - Target health

#### Paso 6.2: Ver Logs de Application Load Balancer

1. Ve a EC2 → Load Balancers
2. Selecciona tu Load Balancer
3. Tab **Monitoring** para ver métricas

#### Paso 6.3: Actualizar Aplicación

```bash
# Hacer cambios en el código
# Commit y push a GitHub
git add .
git commit -m "Update: nueva funcionalidad"
git push origin main

# GitHub Actions automáticamente:
# 1. Ejecutará tests
# 2. Construirá nuevas imágenes
# 3. Subirá a DockerHub

# Para actualizar instancias EC2:
# Opción 1: Terminar instancias manualmente (ASG creará nuevas con imágenes actualizadas)
# Opción 2: SSH a cada instancia y hacer docker-compose pull
```

**Actualización automática en EC2:**
```bash
# Conectar a EC2
ssh -i visitor-counter-key.pem ec2-user@[EC2_PUBLIC_IP]

# Actualizar
cd ~
sudo docker-compose pull
sudo docker-compose up -d

exit
```

---

### **FASE 7: LIMPIEZA DE RECURSOS (IMPORTANTE)**

#### ⚠️ IMPORTANTE: Para evitar cargos en AWS

```bash
cd terraform

# Destruir toda la infraestructura
terraform destroy

# Escribir 'yes' cuando se solicite confirmación
```

Esto eliminará:
- Auto Scaling Group e instancias EC2
- Load Balancer
- Target Groups
- Security Groups
- VPC y subnets
- Roles IAM

#### Eliminar Key Pair (opcional)

```bash
aws ec2 delete-key-pair --key-name visitor-counter-key
del visitor-counter-key.pem
```

---

## 🧪 Comandos de Prueba Rápidos

### Probar Backend directamente
```bash
# Health check
curl http://localhost:3000/health

# Obtener contador
curl http://localhost:3000/api/visitors

# Incrementar
curl -X POST http://localhost:3000/api/visitors/increment

# Reset
curl -X POST http://localhost:3000/api/visitors/reset
```

### Probar a través del Load Balancer
```bash
# Reemplazar [LB_URL] con tu URL del Load Balancer
curl http://[LB_URL]/health
curl http://[LB_URL]/api/visitors
curl -X POST http://[LB_URL]/api/visitors/increment
```

---

## 🔍 Troubleshooting

### Problema: GitHub Actions falla en push a DockerHub
**Solución**: Verificar que los secretos DOCKERHUB_USERNAME y DOCKERHUB_TOKEN estén correctamente configurados

### Problema: Instancias EC2 no levantan contenedores
**Solución**: 
```bash
# Conectar por SSH y verificar logs
ssh -i visitor-counter-key.pem ec2-user@[EC2_IP]
cat /home/ec2-user/setup.log
sudo docker-compose logs
```

### Problema: Load Balancer retorna 502/503
**Solución**: Las instancias están inicializándose. Esperar 3-5 minutos adicionales.

### Problema: Frontend no se conecta al backend
**Solución**: Verificar que el nginx.conf tenga la configuración correcta del proxy

---

## 📊 Costos Estimados AWS

Para esta infraestructura en us-east-1:

- **EC2 t3.micro**: ~$0.0104/hora × 3 instancias = ~$0.031/hora
- **Application Load Balancer**: ~$0.0225/hora
- **Total**: ~$0.054/hora o ~$38.88/mes

**⚠️ RECOMENDACIÓN**: Ejecutar `terraform destroy` después de completar las pruebas para evitar cargos.

---

## 🎓 Conceptos Aprendidos

✅ Arquitectura de microservicios con Docker
✅ CI/CD con GitHub Actions
✅ Containerización y orquestación
✅ Infraestructura como código con Terraform
✅ Load Balancing y Auto Scaling en AWS
✅ Seguridad con Security Groups
✅ Pruebas unitarias con Jest
✅ Reverse proxy con Nginx
✅ Automatización de despliegues

---

## 📚 Referencias

- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Auto Scaling](https://docs.aws.amazon.com/autoscaling/)
- [Express.js](https://expressjs.com/)
- [Nginx](https://nginx.org/en/docs/)

---

## 👨‍💻 Autor

**Stev97uce**
- GitHub: [@Stev97uce](https://github.com/Stev97uce)
- DockerHub: [stevxd97](https://hub.docker.com/u/stevxd97)

---

## 📄 Licencia

Este proyecto es parte de una práctica académica.

---

## 🚀 Quick Start (Resumen)

```bash
# 1. Clonar
git clone https://github.com/Stev97uce/Evaluacion.git
cd Evaluacion

# 2. Probar localmente
cd FRONTEND
docker-compose up -d

# 3. Configurar secretos en GitHub
# DOCKERHUB_USERNAME: stevxd97
# DOCKERHUB_TOKEN: [TU_DOCKERHUB_TOKEN]

# 4. Push a GitHub
git add .
git commit -m "Initial commit"
git push origin main

# 5. Desplegar en AWS
cd terraform
aws ec2 create-key-pair --key-name visitor-counter-key --query 'KeyMaterial' --output text > visitor-counter-key.pem
terraform init
terraform apply

# 6. Obtener URL
terraform output load_balancer_url

# 7. Limpiar (IMPORTANTE)
terraform destroy
```

---

**¡Proyecto completado! 🎉**
