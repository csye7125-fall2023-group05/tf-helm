# Terraform Helm Provider

This terraform code is to deploy Helm charts on GKE(GCP) cluster in prod OR minikube cluster locally using terraform [`Terraform Helm Provider`](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)

The helm chart installation cluster depends on the `kubernetes` `config_path` in the `helm` provider.

```tf
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
```

Based on the `KUBECONFIG` value, the helm chart will be installed on that particular cluster.

> Due to an on-going issue with Terraform Helm Provider [[reference](https://github.com/hashicorp/terraform-provider-helm/issues/932)] which prevents the Terraform resource to pull a chart from a private GitHub repository (even after providing a GitHub PAT), we are forced to install the Helm chart locally.

## Kubernetes Provider

We make use of the [`Terraform Kubernetes Provider`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) to help setup the namespaces with appropriate labels. We will use these labels to install/inject [`Istio Service Mesh`](https://istio.io/v1.16/docs/setup/install/helm/) `Envoy proxy` sidecar pods to inject the ingress/egress Istio gateway.

To setup namespaces on a cluster using the Kubernetes provider, we need to configure the `config_path` for the cluster configuration, which will tell terraform to create and configure the namespaces on that cluster.

```tf
provider "kubernetes" {
  config_path = "~/.kube/config"
}
```

## [Istio Service Mesh](https://istio.io/latest/docs/setup/getting-started/)

Istio is an open-source service mesh platform designed to connect, secure, and manage microservices-based applications. A service mesh is a dedicated infrastructure layer that facilitates communication between microservices in a decentralized and resilient manner. Istio provides a set of powerful features and capabilities to address common challenges associated with microservices architectures.

Istio is suitable for organizations adopting microservices architectures where the number of services and their interactions can become complex. It provides a centralized and consistent way to manage and secure these interactions, improving the overall reliability and observability of microservices-based applications.

Here are key aspects and advantages of Istio:

- **`Traffic Management`**:
  - Load Balancing: Istio can evenly distribute incoming traffic across multiple instances of a service to ensure optimal resource utilization and high availability.
  - Canary Releases: Istio allows you to perform controlled rollouts by gradually shifting traffic from one version of a service to another (canary releases), minimizing the risk of introducing bugs or performance issues.

- **`Security`**:
  - **Authentication and Authorization**: Istio enforces authentication and authorization policies for communication between services, ensuring that only authorized services can interact with each other.
  - **Encryption**: Istio supports automatic mutual TLS (mTLS) encryption between services, adding an extra layer of security to communication.

- **`Observability`**:
  - **Monitoring**: Istio provides detailed monitoring and logging capabilities, allowing you to observe the behavior of your microservices and diagnose issues.
  - **Tracing**: Istio supports distributed tracing, helping you understand the flow of requests through your microservices architecture and identify performance bottlenecks.

- **`Resilience`**:
  - **Circuit Breaking**: Istio can automatically detect when a service is failing and prevent further requests from being sent to it, allowing the system to gracefully degrade instead of cascading failures.
  - **Timeouts and Retries**: Istio enables you to configure timeouts and retries for service-to-service communication, improving the resilience of your applications.

- **`Policy Enforcement`**:
  - **Rate Limiting**: Istio allows you to enforce rate limits on incoming requests to prevent abuse or ensure fair resource utilization.
  - **Access Control Lists (ACLs)**: Istio lets you define fine-grained access control policies for services, restricting communication based on various criteria.

- **`Service Mesh Federation`**:
  - **Multi-Cluster Support**: Istio can be used to create a service mesh that spans multiple Kubernetes clusters, enabling communication and management across diverse environments.

- **`Easier Development and Operations`**:
  - **Automatic Sidecar Injection**: Istio deploys a sidecar proxy alongside each microservice, which handles communication and offloads concerns such as security and monitoring. This simplifies the development and operation of individual services.

### Working with Istio

- The istio helm charts are installed automatically and in their own namespaces. To install these charts manually without terraform, but using helm, [refer the official documentation](https://istio.io/v1.16/docs/setup/install/helm/).

- There are 3 main Istio [charts](https://istio-release.storage.googleapis.com/charts) that we require for Istio service mesh to be fully functional:
  - `istio/base`: The Istio base chart which contains cluster-wide resources used by the Istio control plane
  - `istio/istiod`: The Istio discovery chart which deploys the `istiod` service
  - `istio/gateway`: (Optional) Install an ingress gateway

- To inject Envoy proxy sidecar pods to all pods in a namespace, simply add the label `istio-injection=enabled` to the namespace:

  ```bash
  kubectl label namespace <namespace-name>istio-injection=enabled
  ```

- To exclude a namespace from Envoy proxy sidecar pods, use the label `istio-injection=disabled`

  ```bash
  kubectl label namespace <namespace-name>istio-injection=disabled
  ```

- (Optional) Install `istioctl`:

> NOTE: We will use this tool to analyze namespaces and to verify if the pods have been injected with Istio sidecar pods

```bash
brew install istioctl
# Prints out build version information
istioctl version
# Analyze Istio configuration and print validation messages
istioctl analyze
```

## Configuring the chart values

For specific `values.yaml`, refer their specific charts and create their respective `values.yaml` files based on the dummy `values.yaml` file.
