# webhook-kubectl 

A Docker image containing [webhook](https://github.com/adnanh/webhook), [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/), and additional useful tools.

Great for automating Kubernetes maintenance operations! ☸️

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/weibeld/webhook-kubectl?color=blue&label=docker%20hub&logo=docker&logoColor=white&sort=semver)](https://hub.docker.com/r/weibeld/webhook-kubectl)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/weibeld/webhook-kubectl?color=blue&label=image%20size&logo=docker&logoColor=white&sort=semver)

## Description

The Docker image is based on [Alpine](https://www.alpinelinux.org/).

Besides [webhook](https://github.com/adnanh/webhook) and [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/), the latest version of this image includes the following tools:

- [jq](https://stedolan.github.io/jq/)

> **Note:** the image also includes the [`gcompat`](https://pkgs.alpinelinux.org/package/edge/community/x86/gcompat) compatibility layer for GNU libc on top of [musl libc](https://musl.libc.org/). This allows binaries that are dynamically linked against GNU libc to run in this container. This is necessary because [Alpine uses musl libc](https://www.alpinelinux.org/posts/Alpine-Linux-has-switched-to-musl-libc.html) rather than GNU libc.

The image does not define a default command or entrypoint, so if you want to run the `webhook` command, you have to specify it explicitly when running the image (see [_Usage_](#usage) below).

## Usage

Assuming you have a [webhook config file](https://github.com/adnanh/webhook#configuration) named `hooks.yaml` in your current working directory, you can run the Docker image as follows:
 
```bash
docker run \
  -p 9000:9000 \
  -v "$PWD"/hooks.yaml:/home/hooks.yaml \
  weibeld/webhook-kubectl:0.0.1 \
  webhook --hooks /home/hooks.yaml
```

> **Note:** you have to explicitly specify the `webhook` command since the image does not define an entrypoint command.

## Using kubectl

If you deploy the image to a Kubernetes cluster, then kubectl configures itself to acess this cluster by using the information injected into each container by Kubernetes. This includes the Pod's ServiceAccount token (`/var/run/secrets/kubernetes.io/serviceaccount/token`) for authentication.

So, if you want to access the cluster that kubectl is running in you don't need a kubeconfig file or any other configuration.

If you want to access a different cluster, or deploy the image outside of Kubernetes, you need to provide an appropriate kubeconfig file to kubectl in the container.

In any case, for granting permissions to kubectl, you need to create appropriate [Roles](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#role-v1-rbac-authorization-k8s-io)/[ClusterRoles](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#clusterrole-v1-rbac-authorization-k8s-io) in the target cluster and bind them to the [ServiceAccount or user](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) used by kubectl with corresponding [RoleBindings](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#rolebinding-v1-rbac-authorization-k8s-io)/[ClusterRoleBindings](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#clusterrolebinding-v1-rbac-authorization-k8s-io).
