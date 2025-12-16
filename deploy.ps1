# Script de despliegue rápido para AWS (PowerShell)
# Uso: .\deploy.ps1 [init|plan|apply|destroy|output|key]

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('init','plan','apply','destroy','output','key')]
    [string]$Action
)

$TERRAFORM_DIR = "terraform"
$KEY_NAME = "visitor-counter-key"

Set-Location $PSScriptRoot

switch ($Action) {
    'init' {
        Write-Host "🔧 Inicializando Terraform..." -ForegroundColor Cyan
        Set-Location $TERRAFORM_DIR
        terraform init
    }
    
    'plan' {
        Write-Host "📋 Generando plan de ejecución..." -ForegroundColor Cyan
        Set-Location $TERRAFORM_DIR
        terraform plan
    }
    
    'apply' {
        Write-Host "🚀 Desplegando infraestructura en AWS..." -ForegroundColor Cyan
        Set-Location $TERRAFORM_DIR
        terraform apply -auto-approve
        Write-Host ""
        Write-Host "✅ Despliegue completado!" -ForegroundColor Green
        Write-Host "🌐 URL de la aplicación:" -ForegroundColor Yellow
        terraform output load_balancer_url
    }
    
    'destroy' {
        Write-Host "🗑️  Destruyendo infraestructura..." -ForegroundColor Red
        $confirm = Read-Host "¿Estás seguro? (yes/no)"
        if ($confirm -eq 'yes') {
            Set-Location $TERRAFORM_DIR
            terraform destroy -auto-approve
            Write-Host "✅ Recursos eliminados" -ForegroundColor Green
        } else {
            Write-Host "❌ Operación cancelada" -ForegroundColor Yellow
        }
    }
    
    'output' {
        Write-Host "📊 Outputs de Terraform:" -ForegroundColor Cyan
        Set-Location $TERRAFORM_DIR
        terraform output
    }
    
    'key' {
        Write-Host "🔑 Creando Key Pair para EC2..." -ForegroundColor Cyan
        $keyMaterial = aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text
        $keyMaterial | Out-File -FilePath "$KEY_NAME.pem" -Encoding ASCII -NoNewline
        Write-Host "✅ Key creado: $KEY_NAME.pem" -ForegroundColor Green
    }
}

Set-Location $PSScriptRoot
