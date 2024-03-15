#!/bin/bash

# Verifica si el espacio de nombres default existe
if ! kubectl get namespace default &> /dev/null; then
    # Si no existe, lo crea
    kubectl create namespace default
fi

# Establece el espacio de nombres actual como default
kubectl config set-context --current --namespace=default

# Nombre base para los archivos CERT y KEY basado en el nombre del archivo YAML
YAML_BASE_NAME="ingress-wildcard-host"

# Define los nombres de archivo para el certificado y la clave basados en el archivo YAML
CERT_FILE="${YAML_BASE_NAME}.crt"
KEY_FILE="${YAML_BASE_NAME}.key"

# Define el archivo de configuración de OpenSSL
OPENSSL_CONF="openssl.cnf"

# Genera el certificado y la clave utilizando OpenSSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $KEY_FILE -out $CERT_FILE -config $OPENSSL_CONF

# Codifica el certificado y la clave en Base64
ENCODED_CERT=$(base64 -w 0 $CERT_FILE)
ENCODED_KEY=$(base64 -w 0 $KEY_FILE)

# Reemplaza los valores en ingress-wildcard-host.yaml
sed -i "s/base64 encoded cert/${ENCODED_CERT}/" ingress-wildcard-host.yaml
sed -i "s/base64 encoded key/${ENCODED_KEY}/" ingress-wildcard-host.yaml

# Aplica los archivos YAML a Kubernetes
kubectl apply -f ingress-wildcard-host.yaml
