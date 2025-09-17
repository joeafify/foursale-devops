#!/bin/bash

set -e

ENVIRONMENT=${1:-dev}
ACTION=${2:-plan}

if [[ ! "$ENVIRONMENT" =~ ^(dev|prod)$ ]]; then
    echo "Error: Environment must be 'dev' or 'prod'"
    exit 1
fi

if [[ ! "$ACTION" =~ ^(plan|apply|destroy)$ ]]; then
    echo "Error: Action must be 'plan', 'apply', or 'destroy'"
    exit 1
fi

echo "🚀 Deploying infrastructure for $ENVIRONMENT environment..."

cd "$(dirname "$0")/../environments/$ENVIRONMENT"

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Run the specified action
case $ACTION in
    plan)
        terraform plan
        ;;
    apply)
        terraform apply -auto-approve
        echo "✅ Infrastructure deployed successfully!"
        echo "📋 To configure kubectl, run:"
        terraform output -raw configure_kubectl
        ;;
    destroy)
        echo "⚠️  WARNING: This will destroy all infrastructure in $ENVIRONMENT!"
        read -p "Are you sure? (yes/no): " confirm
        if [[ $confirm == "yes" ]]; then
            terraform destroy -auto-approve
            echo "🗑️  Infrastructure destroyed."
        else
            echo "❌ Destroy cancelled."
        fi
        ;;
esac