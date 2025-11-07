output "cluster_name" {
  value = aws_eks_cluster.demo-eks-cluster.name
}
output "cluster_arn" {
  value = aws_eks_cluster.demo-eks-cluster.arn
}