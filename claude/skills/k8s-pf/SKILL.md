---
description: Port-forward to a pod in the MJ dev EKS cluster. Handles AWS SSO auth check, kubeconfig setup, pod selection across product/milvus/data namespaces, and Istio mTLS exec workaround. Usage: /k8s-pf [service or namespace hint]
allowed-tools: Bash(aws *) Bash(kubectl *)
---

## Cluster

AWS profile: `mj-dev` | Region: `eu-central-1` | Cluster: `dev-eks`
RBAC access: `product`, `milvus`, `data` namespaces — get/list pods, port-forward, exec, logs

## Auth status

!`aws sts get-caller-identity --profile mj-dev 2>&1 || true`

## Pods — product

!`kubectl get pods -n product 2>&1 | head -20 || true`

## Pods — milvus

!`kubectl get pods -n milvus 2>&1 | head -20 || true`

## Pods — data

!`kubectl get pods -n data 2>&1 | head -20 || true`

## Task

Target: **$ARGUMENTS**

Work through this in order:

**1. Fix auth if broken**
If the auth status above shows an error, run these before anything else:
```bash
aws sso login --profile mj-dev
aws eks update-kubeconfig --region eu-central-1 --name dev-eks --profile mj-dev
```

**2. Pick the pod**
From the pod list above, identify the right pod for the target. If `$ARGUMENTS` is empty, ask the user which service they want to reach.

**3. Port-forward**
Read the container port from the pod spec, don't guess:
```bash
kubectl get pod -n <namespace> <pod-name> -o jsonpath='{range .spec.containers[*]}{.name}{"\t"}{.ports}{"\n"}{end}'
kubectl port-forward -n <namespace> pod/<pod-name> <local-port>:<container-port>
```

**4. Verify reachability**
Routes vary by service — probe common paths to confirm traffic flows and find the right one:
```bash
for p in /healthz /readyz /health /ready /api/v1/health /metrics /docs /; do
  printf "%-18s " "$p"
  curl -s -m 3 -o /dev/null -w "%{http_code}\n" "http://localhost:<local-port>$p"
done
```
Any non-timeout response (even 404) means the forward is working — the app just doesn't define that route.

**5. Istio mTLS workaround**
If every probe hangs/times out, the pod likely has Istio strict mTLS and plain HTTP gets dropped at the sidecar. Use exec to curl from inside the mesh instead:
```bash
kubectl exec -n <namespace> <pod-name> -- curl -s http://localhost:<container-port>/<path>
```
For repeated requests: `kubectl exec -it -n <namespace> <pod-name> -- sh`
