#!/bin/bash

# Script de despliegue rápido para AWS
# Uso: ./deploy.sh [init|plan|apply|destroy|output]

set -e

TERRAFORM_DIR="terraform"
KEY_NAME="visitor-counter-key"

cd "$(dirname "$0")"

case "$1" in
    init)
        echo "🔧 Inicializando Terraform..."
        cd $TERRAFORM_DIR
        terraform init
        ;;
    
    plan)
        echo "📋 Generando plan de ejecución..."
        cd $TERRAFORM_DIR
        terraform plan
        ;;
    
    apply)
        echo "🚀 Desplegando infraestructura en AWS..."
        cd $TERRAFORM_DIR
        terraform apply -auto-approve
        echo ""
        echo "✅ Despliegue completado!"
        echo "🌐 URL de la aplicación:"
        terraform output load_balancer_url
        ;;
    
    destroy)
        echo "🗑️  Destruyendo infraestructura..."
        cd $TERRAFORM_DIR
        terraform destroy -auto-approve
        echo "✅ Recursos eliminados"
        ;;
    
    output)
        echo "📊 Outputs de Terraform:"
        cd $TERRAFORM_DIR
        terraform output
        ;;
    
    key)
        echo "🔑 Creando Key Pair para EC2..."
        aws ec2 create-key-pair \
            --key-name $KEY_NAME \
            --query 'KeyMaterial' \
            --output text > $KEY_NAME.pem
        chmod 400 $KEY_NAME.pem
        echo "✅ Key creado: $KEY_NAME.pem"
        ;;
    
    *)
        echo "Uso: $0 {init|plan|apply|destroy|output|key}"
        echo ""
        echo "Comandos:"
        echo "  init    - Inicializar Terraform"
        echo "  plan    - Ver plan de ejecución"
        echo "  apply   - Desplegar infraestructura"
        echo "  destroy - Destruir infraestructura"
        echo "  output  - Ver outputs"
        echo "  key     - Crear Key Pair para EC2"
        exit 1
        ;;
esac
