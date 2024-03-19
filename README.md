# Guía práctica de Docker y Kubernetes en CBL-Mariner

![image](https://github.com/okytek/Guia_practica_de_Docker_y_Kubernetes_en_CBL-Mariner/assets/130212627/15f1623c-aceb-4545-a519-5d63a5cfad09)

```sh
# Este comando crea una copia de seguridad del archivo de configuración actual del Kubelet, config.yaml, guardándola con el nombre config.yaml.backup. Es una práctica recomendada hacer una copia de seguridad antes de realizar cambios en archivos de configuración importantes.
sudo cp /var/lib/kubelet/config.yaml /var/lib/kubelet/config.yaml.backup

# Este comando utiliza sed, una herramienta de edición de texto en línea, para añadir una nueva línea (maxPods: 50) justo después de la línea que contiene kind: KubeletConfiguration en el archivo config.yaml. Esto configura el máximo de pods que el Kubelet puede administrar en un nodo a 50. Por defecto, este valor suele ser mayor (por ejemplo, 110 en algunas configuraciones).
sudo sed -i '/kind: KubeletConfiguration/a \ \maxPods: 50' /var/lib/kubelet/config.yaml

# Reinicia el servicio Kubelet para aplicar los cambios realizados en el archivo de configuración. Kubelet es el agente que se ejecuta en cada nodo de un clúster de Kubernetes y se asegura de que los contenedores estén corriendo en un Pod.
sudo systemctl restart kubelet

# Este comando muestra el estado actual del servicio Kubelet. Puedes usarlo para verificar si el servicio se ha reiniciado correctamente y está funcionando sin problemas.
sudo systemctl status kubelet

# Muestra los logs del servicio Kubelet. Es útil para diagnosticar problemas o verificar que todo esté funcionando como se espera después de hacer cambios en la configuración.
journalctl -u kubelet

# Muestra una lista de todos los contextos de configuración disponibles. Un contexto define los parámetros de conexión para acceder a un clúster Kubernetes, como el servidor API, el nombre de usuario y el espacio de nombres predeterminado.
kubectl config get-contexts

# Muestra el contexto actualmente seleccionado, es decir, el contexto que se utilizará para las operaciones de Kubernetes.
kubectl config current-context

# Establece el contexto actual para el usuario "kubernetes-admin" en el clúster llamado "kubernetes". Esto cambiará el contexto que se utilizará para las operaciones de Kubernetes.
kubectl config use-context kubernetes-admin@kubernetes

# Renombra el contexto "kubernetes-admin@kubernetes" a "aksws". Esto es útil para cambiar el nombre de un contexto existente en la configuración de kubectl.
kubectl config rename-context kubernetes-admin@kubernetes aksws

# Obtiene una lista de todos los namespaces, deployments, pods, services, secrets e ingress en todos los namespaces disponibles en el clúster Kubernetes.
kubectl get namespaces,deployments,pods,services,secrets,ingress --all-namespaces

# Elimina el deployment especificado en el namespace indicado.
kubectl delete deployment <nombre_del_deployment> -n <nombre_del_namespaces>

# Elimina el service especificado en el namespace indicado.
kubectl delete service <nombre_del_service> -n <nombre_del_namespaces>

# Elimina el secret especificado en el namespace indicado
kubectl delete secret <nombre_del_secret> -n <nombre_del_namespaces>

# Elimina el ingress especificado en el namespace indicado.
kubectl delete ingress <nombre_del_ingress> -n <nombre_del_namespaces>

# Elimina el namespace especificado y todos los recursos contenidos en él.
kubectl delete namespace <nombre_del_namespaces>

# Genera un nuevo token de unión para unir nodos al clúster administrado por kubeadm, y muestra el comando de unión necesario para que otros nodos se unan al clúster.
kubeadm token create --print-join-command
```
