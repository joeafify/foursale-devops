#!/bin/bash
set -e

ENVIRONMENT=${1:-dev}
IMAGE_TAG=${2:-latest}

echo "Deploying to $ENVIRONMENT with tag $IMAGE_TAG"

helm upgrade --install foursale-$ENVIRONMENT k8s/helm/foursale-chart/ \
  --namespace foursale \
  --create-namespace \
  --set image.backend.tag=$IMAGE_TAG \
  --set image.frontend.tag=$IMAGE_TAG \
  --set ingress.hosts[0].host=$ENVIRONMENT.foursale.com \
  --wait \
  --timeout=10m

echo "Deployment completed successfully"