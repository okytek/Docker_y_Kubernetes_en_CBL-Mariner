#!/bin/bash

# Solicitar al usuario el nombre del host
read -p "Ingresa el nombre del host (por ejemplo, vm1.192.168.0.101.nip.io): " nombre_host

# Establecer el nombre del host
hostnamectl set-hostname "$nombre_host" --static

# Actualizar la configuración en /etc/hosts con el nuevo nombre del host
sed -i "s/127.0.0.1   $HOSTNAME/127.0.0.1   $nombre_host/g" /etc/hosts

# Solicitar la dirección IP, máscara de red y puerta de enlace al usuario
read -p "Ingresa la dirección IP y la máscara de red (por ejemplo, 192.168.0.101/24): " direccion_ip_mascara_red
read -p "Ingresa la puerta de enlace (por ejemplo, 192.168.0.1): " puerta_enlace

# Configurar la interfaz de red estática usando systemd
cat > /etc/systemd/network/01-static-en.network << EOF
[Match]
Name=eth0

[Network]
Address=$direccion_ip_mascara_red
Gateway=$puerta_enlace
EOF

# Establecer permisos para el archivo de configuración
chmod 644 /etc/systemd/network/01-static-en.network

# Configurar servidores de nombres en /etc/resolv.conf
servidores_nombres=()
while true; do
    read -p "Ingresa un servidor de nombres (por ejemplo, 190.113.220.18 luego 190.113.220.51 y finalmente 190.113.220.54): " servidor_nombres
    servidores_nombres+=("nameserver $servidor_nombres\n")
    read -p "¿Deseas ingresar otro servidor de nombres? (s/n): " continuar
    if [ "$continuar" != "s" ]; then
        break
    fi
done
cadena_servidores_nombres=$(IFS=''; echo "${servidores_nombres[*]}")
sed -i "s/nameserver 127.0.0.53/$cadena_servidores_nombres/g" /etc/resolv.conf

# Configurar la cadena de búsqueda en /etc/resolv.conf
read -p "Ingresa la cadena de búsqueda (por ejemplo, 192.168.0.101.nip.io): " cadena_busqueda
sed -i "s/search ./search $cadena_busqueda/g" /etc/resolv.conf

# Deshabilitar e detener el servicio iptables
systemctl disable iptables
systemctl stop iptables

# Cargar módulos del kernel para overlay y br_netfilter
modprobe overlay
modprobe br_netfilter

# Habilitar el reenvío de IP en el kernel
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.d/50-security-hardening.conf

# Configurar opciones de red para iptables
cat > /etc/sysctl.d/01-K8s.conf << EOF
net.bridge.bridge-nf-call-iptables = 1
EOF

# Aplicar configuraciones del kernel
sysctl --system

# Instalar paquetes necesarios utilizando tdnf
tdnf -y install conntrack-tools dnsmasq jq kubernetes-client kubernetes-kubeadm moby-cli moby-engine

# Eliminar un archivo de configuración no necesario
rm -rf /etc/cni/net.d/99-loopback.conf.sample

# Configurar la red para el contenedor Docker
cat > /etc/cni/net.d/01-bridge.conf << EOF
{
    "cniVersion": "0.4.0",
    "name": "br",
    "type": "bridge",
    "bridge": "cni0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "subnet": "10.1.0.0/16",
        "routes": [
        { "dst": "0.0.0.0/0" }
        ]
    }
}
EOF

# Configurar la interfaz loopback para el contenedor Docker
cat > /etc/cni/net.d/99-loopback.conf << EOF
{
    "cniVersion": "0.4.0",
    "name": "lo",
    "type": "loopback"
}
EOF

# Habilitar y arrancar el servicio Docker
systemctl enable --now docker.service

# Agregar al usuario actual al grupo Docker
usermod -aG docker "$USER"

# Reiniciar el sistema para aplicar los cambios
reboot
