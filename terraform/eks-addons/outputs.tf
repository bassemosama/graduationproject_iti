output "addon_names" {
  description = "List of deployed EKS add-ons"
  value = [
    aws_eks_addon.vpc_cni.addon_name,
    aws_eks_addon.kube_proxy.addon_name,
    aws_eks_addon.coredns.addon_name,
    aws_eks_addon.ebs_csi_driver.addon_name,
    aws_eks_addon.pod_identity_agent.addon_name
  ]
}

output "vpc_cni_role_arn" {
  value       = aws_iam_role.vpc_cni_pod_role.arn
  description = "Pod Identity IAM role ARN for aws-node"
}

output "ebs_csi_role_arn" {
  value       = aws_iam_role.ebs_csi_pod_role.arn
  description = "Pod Identity IAM role ARN for ebs-csi-controller-sa"
}

