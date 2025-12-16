# ⚡ COMANDOS ÚTILES - REFERENCIA RÁPIDA

Comandos más utilizados durante el desarrollo y despliegue del proyecto.

---

## 🐳 DOCKER

### Construcción
```bash
# Build backend
cd BACKEND
docker build -t stevxd97/visitor-counter-backend:latest .

# Build frontend
cd FRONTEND
docker build -t stevxd97/visitor-counter-frontend:latest .
```

### Ejecución
```bash
# Run backend solo
docker run -d -p 3000:3000 --name backend stevxd97/visitor-counter-backend:latest

# Run frontend + backend con compose
cd FRONTEND
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener
docker-compose down
```

### Gestión
```bash
# Ver contenedores corriendo
docker ps

# Ver todos los contenedores
docker ps -a

# Ver logs de un contenedor
docker logs [CONTAINER_ID]

# Entrar a un contenedor
docker exec -it [CONTAINER_ID] sh

# Detener contenedor
docker stop [CONTAINER_ID]

# Eliminar contenedor
docker rm [CONTAINER_ID]

# Ver imágenes
docker images

# Eliminar imagen
docker rmi [IMAGE_ID]

# Limpiar todo
docker system prune -a --volumes
```

### Push a DockerHub
```bash
# Login
docker login -u stevxd97

# Push backend
docker push stevxd97/visitor-counter-backend:latest

# Push frontend
docker push stevxd97/visitor-counter-frontend:latest
```

---

## 🟢 NODE.JS (Backend)

### Instalación y Testing
```bash
cd BACKEND

# Instalar dependencias
npm install

# Instalar dependencias de producción solamente
npm ci --only=production

# Ejecutar tests
npm test

# Ejecutar tests con coverage
npm test -- --coverage

# Ejecutar servidor en desarrollo
npm run dev

# Ejecutar servidor en producción
npm start
```

### Debugging
```bash
# Ejecutar con inspección
node --inspect server.js

# Ver versión de Node
node --version

# Ver versión de npm
npm --version
```

---

## 🔧 GIT

### Operaciones Básicas
```bash
# Estado actual
git status

# Ver cambios
git diff

# Agregar archivos
git add .
git add BACKEND/server.js

# Commit
git commit -m "feat: descripción del cambio"

# Push
git push origin main

# Pull (actualizar local)
git pull origin main

# Ver historial
git log --oneline
```

### Branches
```bash
# Crear branch
git checkout -b feature/nueva-funcionalidad

# Cambiar de branch
git checkout main

# Listar branches
git branch

# Eliminar branch
git branch -d feature/nombre
```

### Reset y Revert
```bash
# Deshacer último commit (mantiene cambios)
git reset --soft HEAD~1

# Deshacer cambios no commiteados
git checkout -- .

# Ver diferencias con remoto
git diff origin/main
```

---

## ☁️ AWS CLI

### Configuración
```bash
# Configurar credenciales
aws configure

# Ver configuración actual
aws configure list

# Ver identity
aws sts get-caller-identity
```

### EC2
```bash
# Listar instancias
aws ec2 describe-instances --output table

# Listar instancias por tag
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=visitor-counter-asg-instance" \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' \
  --output table

# Crear key pair
aws ec2 create-key-pair \
  --key-name visitor-counter-key \
  --query 'KeyMaterial' \
  --output text > visitor-counter-key.pem

# Eliminar key pair
aws ec2 delete-key-pair --key-name visitor-counter-key

# Terminar instancia
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0
```

### Load Balancer
```bash
# Listar load balancers
aws elbv2 describe-load-balancers --output table

# Describir target groups
aws elbv2 describe-target-groups --output table

# Ver health de targets
aws elbv2 describe-target-health \
  --target-group-arn [ARN]
```

### Auto Scaling
```bash
# Describir Auto Scaling Groups
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names visitor-counter-asg

# Ver instancias en ASG
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names visitor-counter-asg \
  --query 'AutoScalingGroups[0].Instances[*].[InstanceId,HealthStatus,LifecycleState]' \
  --output table

# Terminar instancia en ASG (se crea nueva automáticamente)
aws autoscaling terminate-instance-in-auto-scaling-group \
  --instance-id [INSTANCE_ID] \
  --should-decrement-desired-capacity false

# Cambiar desired capacity
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name visitor-counter-asg \
  --desired-capacity 4
```

### CloudWatch
```bash
# Describir alarmas
aws cloudwatch describe-alarms --output table

# Ver métricas
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=AutoScalingGroupName,Value=visitor-counter-asg \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-01T23:59:59Z \
  --period 3600 \
  --statistics Average
```

---

## 🏗️ TERRAFORM

### Inicialización
```bash
cd terraform

# Inicializar
terraform init

# Actualizar providers
terraform init -upgrade
```

### Planificación y Aplicación
```bash
# Ver plan
terraform plan

# Ver plan y guardar
terraform plan -out=plan.tfplan

# Aplicar plan guardado
terraform apply plan.tfplan

# Aplicar sin confirmación
terraform apply -auto-approve

# Aplicar recurso específico
terraform apply -target=aws_instance.example
```

### Outputs y State
```bash
# Ver outputs
terraform output

# Ver output específico
terraform output load_balancer_url

# Ver state
terraform show

# Listar recursos en state
terraform state list

# Ver recurso específico
terraform state show aws_lb.main
```

### Destrucción
```bash
# Destruir todo
terraform destroy

# Destruir sin confirmación
terraform destroy -auto-approve

# Destruir recurso específico
terraform destroy -target=aws_instance.example
```

### Debugging
```bash
# Validar configuración
terraform validate

# Formatear archivos
terraform fmt

# Ver versión
terraform version

# Logs detallados
TF_LOG=DEBUG terraform apply
```

---

## 🔍 TESTING Y DEBUGGING

### Probar API Local
```bash
# Health check
curl http://localhost:3000/health

# Get visitors
curl http://localhost:3000/api/visitors

# Increment
curl -X POST http://localhost:3000/api/visitors/increment

# Reset
curl -X POST http://localhost:3000/api/visitors/reset

# Con formato JSON bonito (PowerShell)
curl http://localhost:3000/api/visitors | ConvertFrom-Json | ConvertTo-Json
```

### Probar API en AWS
```bash
# Reemplazar [LB_URL] con tu URL
$LB_URL = "visitor-counter-alb-123.us-east-1.elb.amazonaws.com"

curl http://$LB_URL/health
curl http://$LB_URL/api/visitors
curl -X POST http://$LB_URL/api/visitors/increment
```

### Load Testing
```bash
# Hacer múltiples requests (PowerShell)
for ($i=1; $i -le 100; $i++) { 
    curl http://$LB_URL/api/visitors/increment
    Start-Sleep -Milliseconds 100
}

# Ver distribución de requests
for ($i=1; $i -le 20; $i++) { 
    curl -s http://$LB_URL/health | Select-String "timestamp"
}
```

---

## 🔐 SSH Y CONEXIÓN A EC2

### Conectar por SSH
```bash
# Linux/Mac
chmod 400 visitor-counter-key.pem
ssh -i visitor-counter-key.pem ec2-user@[EC2_PUBLIC_IP]

# Windows (PowerShell)
icacls visitor-counter-key.pem /inheritance:r
icacls visitor-counter-key.pem /grant:r "$($env:USERNAME):(R)"
ssh -i visitor-counter-key.pem ec2-user@[EC2_PUBLIC_IP]
```

### Comandos dentro de EC2
```bash
# Ver contenedores
sudo docker ps

# Ver logs
sudo docker-compose logs
sudo docker-compose logs -f backend
sudo docker-compose logs -f frontend

# Reiniciar contenedores
sudo docker-compose restart

# Actualizar imágenes
sudo docker-compose pull
sudo docker-compose up -d

# Ver configuración
cat docker-compose.yml

# Ver logs de inicialización
sudo cat /var/log/cloud-init-output.log

# Ver uso de recursos
top
htop
docker stats
```

---

## 📊 MONITOREO

### Docker Stats
```bash
# Ver uso de recursos de contenedores
docker stats

# Ver uso de recursos específico
docker stats backend frontend
```

### Sistema
```bash
# Dentro de EC2
free -h          # Memoria
df -h            # Disco
top              # Procesos
netstat -tulpn   # Puertos abiertos
```

### Logs
```bash
# Logs de Docker Compose
docker-compose logs --tail=100

# Logs de contenedor específico
docker logs --tail=100 backend

# Seguir logs en tiempo real
docker-compose logs -f

# Logs del sistema (dentro de EC2)
journalctl -u docker
tail -f /var/log/messages
```

---

## 🧹 LIMPIEZA

### Docker
```bash
# Detener todos los contenedores
docker stop $(docker ps -aq)

# Eliminar todos los contenedores
docker rm $(docker ps -aq)

# Eliminar todas las imágenes
docker rmi $(docker images -q)

# Limpieza completa
docker system prune -a --volumes

# Ver espacio usado
docker system df
```

### Terraform
```bash
# Destruir infraestructura
cd terraform
terraform destroy -auto-approve

# Limpiar archivos locales
rm -rf .terraform
rm terraform.tfstate*
rm .terraform.lock.hcl
```

### Git
```bash
# Limpiar archivos no trackeados
git clean -fd

# Reset completo a commit específico
git reset --hard HEAD
```

---

## 🚀 DESPLIEGUE RÁPIDO

### Local
```bash
# 1. Backend
cd BACKEND
npm install
npm test
npm start

# 2. Frontend + Backend con Docker
cd ../FRONTEND
docker-compose up -d
```

### GitHub
```bash
# Push a GitHub (activa CI/CD)
git add .
git commit -m "deploy: new version"
git push origin main
```

### AWS
```bash
# Despliegue completo
cd terraform
terraform init
terraform apply -auto-approve

# Obtener URL
terraform output load_balancer_url

# Esperar 5-6 minutos para inicialización completa
```

---

## 📝 NOTAS IMPORTANTES

### Puertos Usados
- `3000` - Backend (Node.js)
- `80` - Frontend (Nginx)

### URLs Importantes
- Local Frontend: `http://localhost`
- Local Backend: `http://localhost:3000`
- GitHub Repo: `https://github.com/Stev97uce/Evaluacion`
- DockerHub: `https://hub.docker.com/u/stevxd97`

### Credenciales
- DockerHub User: `stevxd97`
- DockerHub Token: `[TU_DOCKERHUB_TOKEN]`
- AWS Region: `us-east-1`
- Key Pair Name: `visitor-counter-key`

---

## 🆘 SOLUCIÓN RÁPIDA DE PROBLEMAS

```bash
# Backend no responde
docker-compose restart backend
docker-compose logs backend

# Frontend no se conecta al backend
docker-compose restart
docker-compose logs

# EC2 no levanta contenedores
ssh -i visitor-counter-key.pem ec2-user@[IP]
sudo cat /var/log/cloud-init-output.log
sudo docker-compose logs

# Terraform falla
terraform refresh
terraform plan
terraform validate

# GitHub Actions falla
# Verificar secretos en GitHub
# Verificar sintaxis de .github/workflows/*.yml
```

---

**Tip**: Guarda este archivo para referencia rápida durante el desarrollo y despliegue.
