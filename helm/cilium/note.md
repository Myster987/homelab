```sh
kubectl delete daemonset -n kube-system kube-flannel
kubectl delete daemonset -n kube-system kube-proxy
kubectl delete cm kube-flannel-cfg -n kube-system
```

run before helmfile or set in ansible to not create proxy
