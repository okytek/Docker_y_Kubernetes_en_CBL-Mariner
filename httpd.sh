#!/bin/bash

# Verifica si el espacio de nombres webservers existe
if ! kubectl get namespace webservers &> /dev/null; then
    # Si no existe, lo crea
    kubectl create namespace webservers
fi

# Establece el espacio de nombres actual como webservers
kubectl config set-context --current --namespace=webservers

# Nombre base para los archivos CERT y KEY basado en el nombre del archivo YAML
YAML_BASE_NAME="httpd"

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

# Reemplaza las cadenas en httpd.yaml
sed -i "s/BASE64_ENCODED_TLS_CERTIFICATE/${ENCODED_CERT}/" httpd.yaml
sed -i "s/BASE64_ENCODED_TLS_PRIVATE_KEY/${ENCODED_KEY}/" httpd.yaml

# Aplica los archivos YAML a Kubernetes
kubectl apply -f httpd.yaml
