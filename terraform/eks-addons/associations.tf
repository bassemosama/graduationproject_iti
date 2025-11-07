# VPC CNI (aws-node DaemonSet)
resource "aws_eks_pod_identity_association" "vpc_cni_assoc" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "aws-node"
  role_arn        = aws_iam_role.vpc_cni_pod_role.arn
  # depends_on = [aws_eks_addon.vpc_cni]
}

resource "aws_eks_pod_identity_association" "ebs_csi_assoc" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.ebs_csi_pod_role.arn
  # depends_on = [aws_eks_addon.ebs_csi]
}
