# 🏗️ GUÍA DE EJECUCIÓN PASO A PASO

Esta guía te llevará desde cero hasta tener la aplicación desplegada en AWS con monitoreo completo.

---

## ✅ CHECKLIST PRE-EJECUCIÓN

Antes de empezar, asegúrate de tener:

- [ ] Git instalado
- [ ] Docker Desktop instalado y corriendo
- [ ] Node.js v18+ instalado
- [ ] AWS CLI instalado y configurado
- [ ] Terraform instalado
- [ ] Cuenta de GitHub con acceso
- [ ] Cuenta de DockerHub (usuario: stevxd97)
- [ ] Cuenta de AWS con credenciales activas

---

## 📋 FASE 1: DESARROLLO LOCAL (15 minutos)

### 1.1 Clonar Repositorio
```bash
git clone https://github.com/Stev97uce/Evaluacion.git
cd Evaluacion
```

### 1.2 Probar Backend
```bash
cd BACKEND
npm install
npm test          # Debe pasar todos los tests
npm start         # Servidor en http://localhost:3000
```

**Pruebas manuales:**
```bash
# En otra terminal
curl http://localhost:3000/health
curl http://localhost:3000/api/visitors
curl -X POST http://localhost:3000/api/visitors/increment
```

### 1.3 Probar con Docker Compose
```bash
cd ../FRONTEND
docker-compose up -d
```

Abrir navegador en: http://localhost
- Verificar que carga la interfaz
- Probar incrementar contador
- Verificar que persiste al refrescar

```bash
docker-compose down
```

---

## 📋 FASE 2: GITHUB Y CI/CD (10 minutos)

### 2.1 Configurar Secretos en GitHub

1. Ir a: https://github.com/Stev97uce/Evaluacion/settings/secrets/actions
2. Crear dos secretos:

```
Nombre: DOCKERHUB_USERNAME
Valor:  stevxd97

Nombre: DOCKERHUB_TOKEN
Valor:  [TU_DOCKERHUB_TOKEN]
```

### 2.2 Push Inicial
```bash
git add .
git commit -m "feat: Initial deployment - Visitor Counter App"
git push origin main
```

### 2.3 Verificar GitHub Actions

1. Ir a: https://github.com/Stev97uce/Evaluacion/actions
2. Esperar a que terminen los workflows (2-3 minutos)
3. Verificar que ambos tengan ✅ verde:
   - Backend CI/CD
   - Frontend CI/CD

### 2.4 Verificar DockerHub

Ir a: https://hub.docker.com/u/stevxd97

Deberías ver:
- stevxd97/visitor-counter-backend:latest
- stevxd97/visitor-counter-frontend:latest

---

## 📋 FASE 3: AWS - CONFIGURACIÓN INICIAL (5 minutos)

### 3.1 Configurar AWS CLI
```bash
aws configure
```

Ingresar:
- AWS Access Key ID: [Tu Access Key]
- AWS Secret Access Key: [Tu Secret Key]
- Default region: us-east-1
- Output format: json

### 3.2 Verificar Credenciales
```bash
aws sts get-caller-identity
```

Debe mostrar tu Account ID y User.

### 3.3 Crear Key Pair para SSH

**Opción A (AWS CLI):**
```bash
aws ec2 create-key-pair --key-name visitor-counter-key --query 'KeyMaterial' --output text > visitor-counter-key.pem
```

**Opción B (Consola AWS):**
1. EC2 → Key Pairs → Create Key Pair
2. Nombre: visitor-counter-key
3. Type: RSA
4. Format: .pem
5. Descargar

**En Windows, cambiar permisos:**
```powershell
icacls visitor-counter-key.pem /inheritance:r
icacls visitor-counter-key.pem /grant:r "$($env:USERNAME):(R)"
```

---

## 📋 FASE 4: DESPLIEGUE EN AWS (10-15 minutos)

### 4.1 Preparar Terraform
```bash
cd terraform
terraform init
```

### 4.2 Revisar Plan
```bash
terraform plan
```

Revisar que va a crear:
- 1 VPC
- 2 Subnets
- 1 Internet Gateway
- 2 Security Groups
- 1 Application Load Balancer
- 1 Target Group
- 1 Launch Template
- 1 Auto Scaling Group
- Varios recursos IAM

### 4.3 Aplicar (CREAR RECURSOS)
```bash
terraform apply
```

Escribir: **yes**

⏳ **Tiempo estimado: 8-10 minutos**

### 4.4 Guardar URL del Load Balancer
```bash
terraform output load_balancer_url
```

Ejemplo de salida:
```
http://visitor-counter-alb-1234567890.us-east-1.elb.amazonaws.com
```

**GUARDAR ESTA URL**

---

## 📋 FASE 5: VERIFICACIÓN (10 minutos)

### 5.1 Esperar Inicialización

Las instancias EC2 necesitan tiempo para:
1. Iniciar (1 min)
2. Instalar Docker (2 min)
3. Descargar imágenes (2 min)
4. Levantar contenedores (1 min)

⏳ **Total: 5-6 minutos**

### 5.2 Verificar Health Checks
```bash
aws elbv2 describe-target-health --target-group-arn $(terraform output -raw target_group_arn)
```

Esperar hasta que veas `State: healthy` en al menos 2 targets.

### 5.3 Verificar Instancias EC2
```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=visitor-counter-asg-instance" \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' \
  --output table
```

Deberías ver 3 instancias en estado `running`.

### 5.4 Acceder a la Aplicación

Abrir navegador en la URL del Load Balancer:
```
http://visitor-counter-alb-[ID].us-east-1.elb.amazonaws.com
```

**Verificaciones:**
- ✅ La página carga correctamente
- ✅ El indicador de backend está verde
- ✅ El contador inicia en 0
- ✅ Botón "Incrementar" funciona
- ✅ Botón "Reiniciar" funciona
- ✅ Al refrescar, el valor persiste

### 5.5 Probar Load Balancing

Hacer múltiples requests:
```bash
for ($i=1; $i -le 20; $i++) { 
    curl http://[LOAD_BALANCER_URL]/api/visitors
    Start-Sleep -Milliseconds 500
}
```

---

## 📋 FASE 6: PRUEBAS AVANZADAS (Opcional - 15 minutos)

### 6.1 Conectar por SSH a EC2

```bash
# Obtener IP pública de una instancia
$IP = aws ec2 describe-instances `
  --filters "Name=tag:Name,Values=visitor-counter-asg-instance" `
  --query 'Reservations[0].Instances[0].PublicIpAddress' `
  --output text

# Conectar
ssh -i visitor-counter-key.pem ec2-user@$IP
```

Dentro de la instancia:
```bash
# Ver contenedores
sudo docker ps

# Ver logs
sudo docker-compose logs

# Ver configuración
cat docker-compose.yml

# Verificar salud
curl localhost/health
curl localhost/api/visitors

exit
```

### 6.2 Probar Auto Scaling

Simular carga alta:
```bash
# Instalar stress (dentro de EC2)
ssh -i visitor-counter-key.pem ec2-user@$IP
sudo yum install -y stress
stress --cpu 2 --timeout 600s
```

En otra terminal, monitorear ASG:
```bash
watch -n 5 'aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names visitor-counter-asg --query "AutoScalingGroups[0].[DesiredCapacity,MinSize,MaxSize]" --output text'
```

### 6.3 Ver CloudWatch Metrics

1. AWS Console → CloudWatch → Dashboards
2. Metrics → EC2 → By Auto Scaling Group
3. Seleccionar: visitor-counter-asg
4. Ver: CPUUtilization, NetworkIn, NetworkOut

### 6.4 Ver Logs del Load Balancer

1. AWS Console → EC2 → Load Balancers
2. Seleccionar: visitor-counter-alb
3. Tab "Monitoring"
4. Ver métricas de:
   - Active connections
   - Target response time
   - HTTP 2xx/4xx/5xx counts

---

## 📋 FASE 7: ACTUALIZACIÓN DE LA APLICACIÓN (Opcional)

### 7.1 Hacer un Cambio

Editar `FRONTEND/public/index.html`:
```html
<!-- Cambiar el título -->
<h1>🌐 Contador de Visitas v2.0</h1>
```

### 7.2 Push a GitHub
```bash
git add .
git commit -m "feat: Update title to v2.0"
git push origin main
```

### 7.3 Esperar CI/CD

GitHub Actions automáticamente:
1. Ejecutará tests
2. Construirá nueva imagen
3. Subirá a DockerHub

### 7.4 Actualizar Instancias EC2

**Opción A - Rolling Update (Recomendado):**
```bash
# Terminar instancias una por una
# ASG creará nuevas con la imagen actualizada
aws autoscaling terminate-instance-in-auto-scaling-group \
  --instance-id [INSTANCE_ID] \
  --should-decrement-desired-capacity false
```

**Opción B - Manual en cada instancia:**
```bash
ssh -i visitor-counter-key.pem ec2-user@[IP]
cd ~
sudo docker-compose pull
sudo docker-compose up -d
exit
```

---

## 📋 FASE 8: LIMPIEZA (CRÍTICO - 5 minutos)

### ⚠️ IMPORTANTE: Evitar Cargos en AWS

### 8.1 Destruir Infraestructura
```bash
cd terraform
terraform destroy
```

Escribir: **yes**

⏳ **Tiempo: 5-7 minutos**

### 8.2 Verificar Eliminación

```bash
# Verificar que no hay instancias
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0]]' --output table

# Verificar que no hay load balancers
aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerName,State.Code]' --output table

# Verificar que no hay Auto Scaling Groups
aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].AutoScalingGroupName' --output table
```

### 8.3 Eliminar Key Pair (Opcional)
```bash
aws ec2 delete-key-pair --key-name visitor-counter-key
del visitor-counter-key.pem
```

---

## 🎯 RESUMEN DE TIEMPOS

| Fase | Tiempo Estimado | Acción |
|------|-----------------|--------|
| 1. Desarrollo Local | 15 min | Probar app localmente |
| 2. GitHub & CI/CD | 10 min | Configurar pipelines |
| 3. AWS Setup | 5 min | Configurar AWS CLI |
| 4. Despliegue AWS | 10-15 min | Terraform apply |
| 5. Verificación | 10 min | Probar aplicación |
| 6. Pruebas Avanzadas | 15 min | Opcional |
| 7. Actualización | 10 min | Opcional |
| 8. Limpieza | 5 min | **CRÍTICO** |
| **TOTAL** | **55-75 min** | |

---

## 🔍 TROUBLESHOOTING COMÚN

### Error: "No space left on device" en Docker
```bash
docker system prune -a --volumes
```

### Error: Terraform state locked
```bash
cd terraform
terraform force-unlock [LOCK_ID]
```

### Error: Cannot connect to Load Balancer (502/503)
- Esperar 2-3 minutos más
- Verificar health checks de targets
- Revisar security groups

### Error: GitHub Actions falla en DockerHub login
- Verificar secretos en Settings → Secrets
- Regenerar token en DockerHub si es necesario

### Instancias EC2 no responden
```bash
# Ver logs del user-data
ssh -i visitor-counter-key.pem ec2-user@[IP]
sudo cat /var/log/cloud-init-output.log
```

---

## 📊 COSTOS ESTIMADOS

**Ejecución de prueba (2 horas):**
- 3x EC2 t3.micro: $0.062
- ALB: $0.045
- Data transfer: ~$0.01
- **Total: ~$0.12**

**Mensual (si se deja corriendo):**
- ~$38.88/mes

---

## ✅ CHECKLIST FINAL

Al terminar, deberías tener:

- [x] Código en GitHub
- [x] Imágenes en DockerHub
- [x] GitHub Actions funcionando
- [x] Tests unitarios pasando
- [x] Aplicación desplegada en AWS
- [x] Load Balancer funcionando
- [x] Auto Scaling configurado
- [x] Monitoreo en CloudWatch
- [x] **RECURSOS AWS DESTRUIDOS** ⚠️

---

¡Práctica completada con éxito! 🎉
