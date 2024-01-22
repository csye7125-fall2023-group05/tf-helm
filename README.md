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

> \[!IMPORTANT]\
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

> \[!NOTE]\
> We will use this tool to analyze namespaces and to verify if the pods have been injected with Istio sidecar pods

```bash
brew install istioctl
# Prints out build version information
istioctl version
# Analyze Istio configuration and print validation messages
istioctl analyze
```

> \[!NOTE]\
> Add the `sidecar.istio.io/inject: "false"` annotation to the metadata section of the pod template. This will prevent the Istio sidecar from being injected into that specific pod.

## Monitoring Stack

To setup a monitoring stack, we will use [Prometheus](https://prometheus.io/) and [Grafana](https://grafana.com/).
Instead of installing the helm charts for these applications, we will use the custom helm chart which includes the grafana helm chart as a dependency in the prometheus chart (developed by the prometheus community). We will use the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md) from the prometheus community.

> NOTE: This chart was formerly named prometheus-operator chart, now renamed to more clearly reflect that it installs the kube-prometheus project stack, within which Prometheus Operator is only one component.

### Working with kube-prometheus-stack

1. Get the Helm repository information

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   ```

2. By default, this chart installs additional, dependent charts:

   - [prometheus-community/kube-state-metrics](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-state-metrics)
   - [prometheus-community/prometheus-node-exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-node-exporter)
   - [grafana/grafana](https://github.com/grafana/helm-charts/tree/main/charts/grafana)

   > NOTE: To disable dependencies during installation, see [multiple releases](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md#multiple-releases).

3. To configure the kube-prometheus-stack helm chart, refer the [documentation](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md#configuration). To see the default values, use the command:

   ```bash
   helm show values prometheus-community/kube-prometheus-stack
   ```

> \[!IMPORTANT]\
> [Workaround for known issues on GKE](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md#running-on-private-gke-clusters)
> When Google configure the control plane for private clusters, they automatically configure VPC peering between your Kubernetes cluster’s network and a separate Google managed project. In order to restrict what Google are able to access within your cluster, the firewall rules configured restrict access to your Kubernetes pods. This means that in order to use the webhook component with a GKE private cluster, you must configure an additional firewall rule to allow the GKE control plane access to your webhook pod.
> You can read more information on how to add firewall rules for the GKE control plane nodes in the [GKE docs](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#add_firewall_rules)
> Alternatively, you can disable the hooks by setting `prometheusOperator.admissionWebhooks.enabled=false`.

## Logging Stack

We will use the [EFK stack](https://medium.com/@tech_18484/simplifying-kubernetes-logging-with-efk-stack-158da47ce982) to setup logging for our containerized applications (which are installed via custom helm charts) on kubernetes. The `EFK stack` consists of Elasticsearch, FluentBit and Kibana to streamline the process of collecting, processing and visualizing logs.

- **[Elasticsearch](https://www.elastic.co/elasticsearch)**: NoSQL database based on the `Lucene search engine`. It provides a distributed, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents.
- **[Fluentbit](https://fluentbit.io/)**: Super fast, lightweight, and highly scalable logging and metrics processor and forwarder.
- **[Kibana](https://www.elastic.co/kibana)** — Data visualization dashboard software for Elasticsearch.

> \[NOTE]
> Before installing the Helm chart on an EKS cluster, we must ensure the presence of a storage class and the AWS CSI driver for Elasticsearch. Elasticsearch functions as a database and is often deployed as a stateful set. This deployment configuration necessitates the use of Persistent Volume Claims (PVCs), and to fulfill those claims, we require storage resources. To achieve proper provisioning of EBS (Elastic Block Store) volumes within the EKS cluster, we rely on a storage class with the AWS EBS provisioner. Therefore, the prerequisites for successful EBS provisioning in the EKS cluster encompass the storage class and the EBS CSI driver. Refer [this blog](https://medium.com/@tech_18484/simplifying-kubernetes-logging-with-efk-stack-158da47ce982) for more details.

### Working with EFK Stack

- Get the Helm repository information for elastic and fluentbit tools

   ```bash
   helm repo add elastic https://helm.elastic.co
   helm repo add fluent https://fluent.github.io/helm-charts
   helm repo update
   ```

- Refer the Helm chart default values to configure the charts accordingly

   ```bash
   # example: fluent-bit chart values
   helm show values fluent/fluent-bit > fluentbit-values.yaml
   ```

- To verify elasticsearch is up and running successfully:
  - Run the below commands to get the username and password from the elasticsearch master pod:

      ```bash
      # get elasticsearch username
      kubectl get secrets --namespace=efk elasticsearch-master-credentials -ojsonpath='{.data.username}' | base64 -d
      # get elasticsearch password (exclude '%' at end in output of below command)
      kubectl get secrets --namespace=efk elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d
      ```

  - Access the JSON response by accessing the link `https://<LoadBalancer-IP>:9200` and enter the username and password when prompted. Here the `LoadBalancer-IP` is the `External IP` provided to the elasticsearch service.

- To verify Kibana is up and running successfully:
  - Run the below commands to get the password and service account token for Kibana from the elasticsearch master pod:

    ```bash
    # get elasticsearch password (exclude '%' at end in output of below command)
    kubectl get secrets --namespace=efk elasticsearch-master-credentials -ojsonpath=’{.data.password}’ | base64 -d
    # get Kibana service account token
    kubectl get secrets --namespace=efk kibana-kibana-es-token -ojsonpath=’{.data.token}’ | base64 -d
    ```

  - Access the Kibana dashboard by accessing the link `https://<LoadBalancer-IP>:5601` and enter the password and service account token when prompted. Here the `LoadBalancer-IP` is the `External IP` provided to the kibana service.

  > \[\NOTE]
  > Depending on the Kibana version installed, the dashboard might prompt to enter the elasticsearch username and password, in which case you do not need to get the service account token.

## Configuring the chart values

For specific `values.yaml`, refer their specific charts and create their respective `values.yaml` files based on the dummy `values.yaml` file. You can also use the `example.*.yaml` files in the `root/` directory to view specific values for the chart values.

> \[NOTE]
> Make sure to configure correct values depending on the kubernetes cluster you deploy to. If you are using minikube to test the deployment, make sure you edit the values accordingly, since minikube is a single-node kubernetes cluster.

## Infrastructure Setup

Once we have all our chart `values.yaml` configured, we can apply our Terraform configuration to install the helm charts to our kubernetes cluster.

- Initialize Terraform

  ```bash
  terraform init
  ```

- Validate the Terraform infrastructure configuration as code

  ```bash
  terraform validate -json
  ```

- Plan the infrastructure setup

  ```bash
  terraform plan -var-file="prod.tfvars"
  ```

- Apply the infrastructure to the kubernetes cluster after verifying the configuration in the previous steps

  ```bash
  terraform apply --auto-approve -var-file="prod.tfvars"
  ```
