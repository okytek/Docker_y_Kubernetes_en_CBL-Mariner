#!/bin/bash

# Solicita al usuario que ingrese la dirección IP del servidor
read -p "Ingrese la dirección IP del servidor (por ejemplo, 192.168.0.101): " direccion_ip

# Inicializa el clúster Kubernetes con la dirección IP proporcionada
sudo kubeadm init --apiserver-advertise-address=$direccion_ip --ignore-preflight-errors=all

# Configura el directorio .kube para el usuario actual
mkdir -p $HOME/.kube

# Copia el archivo de configuración del clúster a la ubicación del usuario
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# Asigna los permisos adecuados al archivo de configuración
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Aplica la configuración estándar de la API Gateway
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml

# Descarga el archivo de configuración de los componentes del servidor de métricas
wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.7.0/components.yaml

# Modifica el archivo de configuración para permitir conexiones inseguras al Kubelet
sed -i 's/        - --metric-resolution=15s/        - --metric-resolution=15s\n        - --kubelet-insecure-tls=true/g' components.yaml

# Aplica la configuración del servidor de métricas
kubectl apply -f components.yaml

# Elimina el archivo temporal de configuración
rm -rf components.yaml

# Quita las restricciones de roles en todos los nodos del clúster
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-
