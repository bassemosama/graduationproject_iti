variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "vpc_cni_version" {
  type        = string
  default     = null
  description = "Version of the VPC CNI add-on"
}

variable "kube_proxy_version" {
  type        = string
  default     = null
  description = "Version of the Kube Proxy add-on"
}

variable "coredns_version" {
  type        = string
  default     = null
  description = "Version of the CoreDNS add-on"
}

variable "ebs_csi_driver_version" {
  type        = string
  default     = null
  description = "Version of the EBS CSI Driver add-on"
}

variable "pod_identity_agent_version" {
  type        = string
  default     = null
  description = "Version of the EKS Pod Identity Agent add-on"
}
