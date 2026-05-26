#!/bin/bash

# ── VARIABLES DE CONFIGURACIÓN ───────────────────────────────────────────────
# Reemplaza estos valores con los tuyos antes de ejecutar.

AWS_ACCOUNT_ID="911526871150"        
AWS_REGION="us-east-2"                
REPO_NAME="lambda-final-repo"          # Nombre del repositorio en ECR
IMAGE_TAG="latest"                     # Etiqueta de la imagen

# Construimos la URL completa del repositorio ECR.
# Formato: <account_id>.dkr.ecr.<region>.amazonaws.com/<repo>
ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"

# ── PASO 1: AUTENTICACIÓN EN ECR ─────────────────────────────────────────────
# Antes de hacer push, Docker necesita autenticarse en ECR.
# "aws ecr get-login-password" genera un token temporal de acceso.
# "docker login" usa ese token para autenticarse.
# --password-stdin → lee la contraseña desde stdin (más seguro que -p).
echo "🔐 Autenticando en Amazon ECR..."
aws ecr get-login-password --region ${AWS_REGION} | \
    docker login --username AWS --password-stdin \
    ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# ── PASO 2: CREAR REPOSITORIO ECR (si no existe) ─────────────────────────────
# ECR es el registro de contenedores de AWS (equivalente a Docker Hub privado).
# Necesitas crear el repositorio ANTES de hacer push.
# "2>/dev/null || true" → si ya existe, ignora el error y continúa.
echo "📦 Creando repositorio ECR (si no existe)..."
aws ecr create-repository \
    --repository-name ${REPO_NAME} \
    --region ${AWS_REGION} \
    2>/dev/null || true

# ── PASO 3: CONSTRUIR LA IMAGEN DOCKER ───────────────────────────────────────
# "docker build" lee el Dockerfile del directorio actual (.)
# "-t ${ECR_URI}:${IMAGE_TAG}" asigna la etiqueta completa con la URL de ECR.
# Etiquetar directamente con la URL de ECR evita un paso extra de "docker tag".
# "--platform linux/amd64" → CRÍTICO: Lambda corre en arquitectura x86_64.
# Si tu Mac es Apple Silicon (M1/M2) o tu PC es ARM, sin este flag
# construirías una imagen ARM que Lambda rechazaría con error.
echo "🔨 Construyendo imagen Docker..."
docker build --platform linux/amd64 -t ${ECR_URI}:${IMAGE_TAG} .

# ── PASO 4: SUBIR LA IMAGEN A ECR ────────────────────────────────────────────
# "docker push" sube todas las capas de la imagen al repositorio ECR.
# Docker solo sube capas que el registro no tenga ya (incremental).
echo "🚀 Subiendo imagen a ECR..."
docker push ${ECR_URI}:${IMAGE_TAG}

echo ""
echo "✅ ¡Despliegue completado exitosamente!"
echo "📌 URI de la imagen: ${ECR_URI}:${IMAGE_TAG}"
echo 