# Guía práctica de Docker y Kubernetes en CBL-Mariner

![image](https://github.com/okytek/Guia_practica_de_Docker_y_Kubernetes_en_CBL-Mariner/assets/130212627/15f1623c-aceb-4545-a519-5d63a5cfad09)

```sh
# Muestra una lista de todos los contextos de configuración disponibles. Un contexto define los parámetros de conexión para acceder a un clúster Kubernetes, como el servidor API, el nombre de usuario y el espacio de nombres predeterminado.
kubectl config get-contexts

# Muestra el contexto actualmente seleccionado, es decir, el contexto que se utilizará para las operaciones de Kubernetes.
kubectl config current-context

kubectl config use-context kubernetes-admin@kubernetes

kubectl config rename-context kubernetes-admin@kubernetes aksws

kubectl get namespaces,deployments,pods,services,secrets,ingress --all-namespaces

kubectl delete deployment <nombre_del_deployment> -n <nombre_del_namespaces>

kubectl delete service <nombre_del_service> -n <nombre_del_namespaces>

kubectl delete secret <nombre_del_secret> -n <nombre_del_namespaces>

kubectl delete ingress <nombre_del_ingress> -n <nombre_del_namespaces>

kubectl delete namespace <nombre_del_namespaces>

kubeadm token create --print-join-command
```
