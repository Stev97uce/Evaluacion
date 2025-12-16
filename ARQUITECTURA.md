# 🏗️ ARQUITECTURA DEL SISTEMA

## 📊 Vista General

```
Internet
   |
   | HTTPS/HTTP
   |
   v
┌──────────────────────────────────────────────────┐
│         AWS Route 53 (Opcional)                  │
└────────────────┬─────────────────────────────────┘
                 |
                 v
┌──────────────────────────────────────────────────┐
│    Application Load Balancer (ALB)              │
│    - Health checks: /health                      │
│    - Port: 80                                    │
│    - Cross-zone: Enabled                         │
└────────┬─────────────────┬───────────────────────┘
         |                 |
    us-east-1a        us-east-1b
         |                 |
         v                 v
┌─────────────────┐  ┌─────────────────┐
│  Public Subnet  │  │  Public Subnet  │
│  10.0.1.0/24    │  │  10.0.2.0/24    │
└────────┬────────┘  └────────┬────────┘
         |                    |
    ┌────┴────────────────────┴────┐
    │    Auto Scaling Group        │
    │    Min: 3  Max: 4            │
    └────┬─────────┬──────────┬────┘
         |         |          |
         v         v          v
    ┌────────┐ ┌────────┐ ┌────────┐
    │  EC2   │ │  EC2   │ │  EC2   │
    │t3.micro│ │t3.micro│ │t3.micro│
    └───┬────┘ └───┬────┘ └───┬────┘
        │          │          │
        └──────────┴──────────┘
                   |
           Docker Compose
                   |
        ┌──────────┴──────────┐
        |                     |
        v                     v
   ┌─────────┐         ┌──────────┐
   │Frontend │         │ Backend  │
   │Container│ ◄─────► │Container │
   │ Nginx   │  proxy  │ Node.js  │
   │  :80    │         │  :3000   │
   └─────────┘         └──────────┘
```

---

## 🔄 Flujo de Datos

```
┌───────┐
│Usuario│
└───┬───┘
    │
    │ 1. HTTP Request
    │    GET /
    │
    v
┌─────────────────┐
│Application Load │
│    Balancer     │
└────────┬────────┘
         │
         │ 2. Forward to
         │    healthy target
         │
         v
┌────────────────────┐
│   EC2 Instance     │
│  ┌──────────────┐  │
│  │ Nginx :80    │  │
│  └───────┬──────┘  │
│          │         │
│          │ 3. Serve
│          │    index.html
│          │         │
│          v         │
│  ┌──────────────┐  │
│  │ index.html   │  │
│  │ (Frontend)   │  │
│  └──────────────┘  │
└────────────────────┘
         │
         │ 4. API Request
         │    /api/visitors
         │
         v
┌────────────────────┐
│   EC2 Instance     │
│  ┌──────────────┐  │
│  │ Nginx :80    │  │
│  └───────┬──────┘  │
│          │         │
│          │ 5. Proxy to
│          │    backend
│          │         │
│          v         │
│  ┌──────────────┐  │
│  │ Node.js      │  │
│  │ :3000        │  │
│  └───────┬──────┘  │
│          │         │
│          │ 6. Process
│          │    & Respond
│          │         │
└──────────┼─────────┘
           │
           │ 7. JSON Response
           │    {"count": 5}
           │
           v
       ┌───────┐
       │Usuario│
       └───────┘
```

---

## 🔐 Security Groups

```
┌────────────────────────────────────────┐
│         Internet (0.0.0.0/0)           │
└───────────────┬────────────────────────┘
                │
                │ Port 80 (HTTP)
                │ Port 443 (HTTPS)
                │
                v
┌───────────────────────────────────────┐
│      ALB Security Group               │
│                                       │
│  Inbound:                             │
│    - 80   from 0.0.0.0/0             │
│    - 443  from 0.0.0.0/0             │
│                                       │
│  Outbound:                            │
│    - All traffic to EC2 SG           │
└───────────────┬───────────────────────┘
                │
                │ Port 80
                │
                v
┌───────────────────────────────────────┐
│      EC2 Security Group               │
│                                       │
│  Inbound:                             │
│    - 80    from ALB SG               │
│    - 3000  from ALB SG               │
│    - 22    from specific IP          │
│                                       │
│  Outbound:                            │
│    - All traffic to 0.0.0.0/0       │
│      (DockerHub, yum repos, etc)    │
└───────────────────────────────────────┘
```

---

## 🚀 CI/CD Pipeline

```
┌──────────────┐
│  Developer   │
└──────┬───────┘
       │
       │ git push
       │
       v
┌─────────────────────────────────────┐
│           GitHub                    │
│                                     │
│  ┌──────────────────────────────┐  │
│  │   BACKEND/ changed           │  │
│  │                              │  │
│  │   Trigger: backend.yml       │  │
│  └───────────┬──────────────────┘  │
│              │                     │
│              v                     │
│  ┌──────────────────────────────┐  │
│  │  1. Checkout code            │  │
│  │  2. Setup Node.js 18         │  │
│  │  3. npm install              │  │
│  │  4. npm test ✅              │  │
│  │  5. Build Docker image       │  │
│  │  6. Push to DockerHub        │  │
│  └───────────┬──────────────────┘  │
│              │                     │
└──────────────┼─────────────────────┘
               │
               v
┌──────────────────────────────────────┐
│          DockerHub                   │
│                                      │
│  stevxd97/visitor-counter-backend   │
│  stevxd97/visitor-counter-frontend  │
│                                      │
│  Tags: latest, main-[sha]           │
└──────────────┬───────────────────────┘
               │
               │ docker pull
               │
               v
┌──────────────────────────────────────┐
│       AWS EC2 Instances              │
│                                      │
│  User Data Script:                   │
│  1. Install Docker                   │
│  2. Install Docker Compose           │
│  3. docker-compose pull              │
│  4. docker-compose up -d             │
└──────────────────────────────────────┘
```

---

## 🔄 Auto Scaling

```
┌─────────────────────────────────────────┐
│         CloudWatch Metrics              │
│                                         │
│  - CPUUtilization                       │
│  - NetworkIn/NetworkOut                 │
│  - TargetResponseTime                   │
└────────┬────────────────────────────────┘
         │
         │ Metrics
         │
         v
┌─────────────────────────────────────────┐
│         CloudWatch Alarms               │
│                                         │
│  ┌────────────────────────────────┐    │
│  │ CPU > 70% for 2 periods        │    │
│  │ Action: Scale Up (+1 instance) │    │
│  └────────────────────────────────┘    │
│                                         │
│  ┌────────────────────────────────┐    │
│  │ CPU < 20% for 2 periods        │    │
│  │ Action: Scale Down (-1)        │    │
│  └────────────────────────────────┘    │
└────────┬────────────────────────────────┘
         │
         │ Trigger
         │
         v
┌─────────────────────────────────────────┐
│      Auto Scaling Group                 │
│                                         │
│  Current: 3 instances                   │
│  Min: 3                                 │
│  Max: 4                                 │
│  Desired: 3                             │
│                                         │
│  Scaling Policy:                        │
│  - Cooldown: 300s                       │
│  - Health Check Grace: 300s             │
└─────────────────────────────────────────┘
```

---

## 📦 Contenedores en EC2

```
┌──────────────────────────────────────────────┐
│           EC2 Instance (t3.micro)            │
│                                              │
│  ┌────────────────────────────────────────┐ │
│  │     Docker Network: visitor-network    │ │
│  │                                        │ │
│  │  ┌─────────────────────────────────┐  │ │
│  │  │  Frontend Container             │  │ │
│  │  │  ────────────────────────────   │  │ │
│  │  │  Image: stevxd97/...-frontend  │  │ │
│  │  │  Port: 80                       │  │ │
│  │  │  ┌──────────────────────────┐   │  │ │
│  │  │  │  Nginx                   │   │  │ │
│  │  │  │  - Serve static files    │   │  │ │
│  │  │  │  - Reverse proxy /api/*  │   │  │ │
│  │  │  │  - Gzip compression      │   │  │ │
│  │  │  └──────────────────────────┘   │  │ │
│  │  └─────────────┬───────────────────┘  │ │
│  │                │ proxy_pass            │ │
│  │                v                       │ │
│  │  ┌─────────────────────────────────┐  │ │
│  │  │  Backend Container              │  │ │
│  │  │  ────────────────────────────   │  │ │
│  │  │  Image: stevxd97/...-backend   │  │ │
│  │  │  Port: 3000                     │  │ │
│  │  │  ┌──────────────────────────┐   │  │ │
│  │  │  │  Node.js + Express       │   │  │ │
│  │  │  │  - GET /health           │   │  │ │
│  │  │  │  - GET /api/visitors     │   │  │ │
│  │  │  │  - POST /api/visitors/*  │   │  │ │
│  │  │  │  - In-memory counter     │   │  │ │
│  │  │  └──────────────────────────┘   │  │ │
│  │  └─────────────────────────────────┘  │ │
│  │                                        │ │
│  └────────────────────────────────────────┘ │
│                                              │
│  Health Check:                               │
│  wget http://localhost:3000/health           │
│                                              │
└──────────────────────────────────────────────┘
```

---

## 🗺️ Diagrama de Red (VPC)

```
┌─────────────────────────────────────────────────────────┐
│                    AWS Cloud                            │
│  ┌───────────────────────────────────────────────────┐  │
│  │         VPC (10.0.0.0/16)                         │  │
│  │                                                   │  │
│  │  ┌─────────────────────┐  ┌─────────────────────┐ │  │
│  │  │ Public Subnet 1     │  │ Public Subnet 2     │ │  │
│  │  │ 10.0.1.0/24         │  │ 10.0.2.0/24         │ │  │
│  │  │ us-east-1a          │  │ us-east-1b          │ │  │
│  │  │                     │  │                     │ │  │
│  │  │ ┌─────────────────┐ │  │ ┌─────────────────┐ │ │  │
│  │  │ │ EC2 Instance    │ │  │ │ EC2 Instance    │ │ │  │
│  │  │ │ 10.0.1.x        │ │  │ │ 10.0.2.x        │ │ │  │
│  │  │ └─────────────────┘ │  │ └─────────────────┘ │ │  │
│  │  │ ┌─────────────────┐ │  │ ┌─────────────────┐ │ │  │
│  │  │ │ EC2 Instance    │ │  │ │ EC2 Instance    │ │ │  │
│  │  │ │ 10.0.1.y        │ │  │ │ 10.0.2.y        │ │ │  │
│  │  │ └─────────────────┘ │  │ └─────────────────┘ │ │  │
│  │  └─────────┬───────────┘  └─────────┬───────────┘ │  │
│  │            │                        │             │  │
│  │            └────────────┬───────────┘             │  │
│  │                         │                         │  │
│  │                  ┌──────▼──────┐                  │  │
│  │                  │   Route     │                  │  │
│  │                  │   Table     │                  │  │
│  │                  └──────┬──────┘                  │  │
│  │                         │                         │  │
│  └─────────────────────────┼─────────────────────────┘  │
│                            │                            │
│                     ┌──────▼──────┐                     │
│                     │  Internet   │                     │
│                     │   Gateway   │                     │
│                     └──────┬──────┘                     │
│                            │                            │
└────────────────────────────┼────────────────────────────┘
                             │
                             v
                        Internet
```

---

## ⚡ Tecnologías Utilizadas

### Frontend
- **HTML5/CSS3/JavaScript** - Interfaz de usuario
- **Nginx** - Servidor web y reverse proxy
- **Docker** - Containerización

### Backend
- **Node.js 18** - Runtime JavaScript
- **Express.js** - Framework web
- **Jest + Supertest** - Testing
- **Docker** - Containerización

### DevOps
- **Docker Compose** - Orquestación local
- **GitHub Actions** - CI/CD
- **DockerHub** - Registry de imágenes

### Infraestructura (AWS)
- **EC2** - Instancias de cómputo (t3.micro)
- **Application Load Balancer** - Balanceo de carga
- **Auto Scaling Group** - Escalado automático
- **VPC** - Red privada virtual
- **Security Groups** - Firewall
- **CloudWatch** - Monitoreo y alarmas
- **IAM** - Gestión de permisos
- **Terraform** - Infrastructure as Code

---

## 📈 Escalabilidad

### Horizontal Scaling
- Auto Scaling Group maneja instancias automáticamente
- Min: 3 instancias (alta disponibilidad)
- Max: 4 instancias (control de costos)
- Triggers: CPU > 70% (scale up), CPU < 20% (scale down)

### Vertical Scaling (Futuro)
- Cambiar instance_type en Terraform
- Opciones: t3.small, t3.medium, t3.large

### Geographic Scaling (Futuro)
- Multi-region deployment
- Route 53 con latency-based routing
- CloudFront CDN

---

## 🔒 Seguridad

### Network Security
- VPC isolation
- Security Groups con mínimo privilegio
- Solo puerto 80/443 expuesto a internet
- SSH solo desde IP específica

### Container Security
- Imágenes base oficiales (node:18-alpine, nginx:alpine)
- No root user en contenedores
- Health checks configurados
- Restart policies

### Application Security
- CORS configurado
- Security headers (X-Frame-Options, X-Content-Type-Options)
- Gzip compression
- Rate limiting (posible implementación futura)

### IAM Security
- Roles con permisos mínimos necesarios
- Instance profiles para EC2
- No credenciales hardcoded

---

## 📊 Monitoreo y Observabilidad

### Métricas Disponibles
- **EC2**: CPU, Memory, Network, Disk
- **ALB**: Request count, Target health, Response time
- **ASG**: Instances count, Scaling activities
- **Container**: Health checks, Restart count

### Logs Disponibles
- Docker container logs
- Cloud-init logs
- Nginx access/error logs
- Application logs

### Alertas Configuradas
- CPU Alta (> 70%)
- CPU Baja (< 20%)
- Target unhealthy

---

Este diseño permite:
- ✅ Alta disponibilidad
- ✅ Escalabilidad automática
- ✅ Despliegue continuo
- ✅ Monitoreo completo
- ✅ Seguridad robusta
