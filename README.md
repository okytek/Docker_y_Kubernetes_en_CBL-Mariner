# Guía práctica de Docker y Kubernetes en CBL-Mariner

![image](https://github.com/okytek/Guia_practica_de_Docker_y_Kubernetes_en_CBL-Mariner/assets/130212627/15f1623c-aceb-4545-a519-5d63a5cfad09)

```sh
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
