
module "myvpc" {
  source   = "./vpc"
  vpc_cidr = var.vpc_cidr
  tags     = var.tags
}


module "publicsubnet" {
  count  = length(var.subnet-cidr)
  source = "./publicsubnets"

  vpc_id      = module.myvpc.vpc_id
  subnet-cidr = var.subnet-cidr[count.index]
  azs         = var.azs[count.index]
  tags        = var.tags
}


module "privatesubnet" {
  count  = length(var.privatesubnet-cidr)
  source = "./privatesubnets"

  vpc_id            = module.myvpc.vpc_id
  subnet-cidr       = var.privatesubnet-cidr[count.index]
  azs               = var.azs[count.index]
  tags              = var.tags
}


module "myigw" {
  source     = "./igw"
  thevpc_id  = module.myvpc.vpc_id
  tags       = var.tags
}


module "natgateway" {
  source           = "./natgw"
  public_subnet_id = module.publicsubnet[0].subnet_id
  tags             = var.tags
}


module "privateroutetable" {
  source        = "./privateroutetable"
  vpc_id        = module.myvpc.vpc_id
  natgateway_id = module.natgateway.mynategaway_id
  tags          = var.tags
}


module "publicroutetable" {
  source = "./publicroutetable"
  vpc_id = module.myvpc.vpc_id
  igw_id = module.myigw.inetnetgateway_id
  tags   = var.tags
}


module "publictableassociation" {
  count          = length(var.subnet-cidr)
  source         = "./publictableasso"
  subnet_id      = module.publicsubnet[count.index].subnet_id
  route_table_id = module.publicroutetable.public_route_table_id
}

module "privatetableassociation" {
  count          = length(var.privatesubnet-cidr)
  source         = "./privatetableasso"
  subnet_id      = module.privatesubnet[count.index].privatesubnet_id
  route_table_id = module.privateroutetable.private_route_table_id
}


module "ekscluster" {
  source       = "./ekscluster"
  cluster_name = var.cluster_name
  subnet_ids = [for s in module.privatesubnet : s.privatesubnet_id]

  tags        = var.tags
  eks_version = var.eks_version

  depends_on = [
    module.myvpc,
    module.privatesubnet,
    module.publicsubnet,
    module.privateroutetable,
    module.publicroutetable
  ]
}


module "nodegrp" {
  source       = "./nodegrp"
  cluster_name = var.cluster_name
  subnet_ids = [for s in module.privatesubnet : s.privatesubnet_id]

  depends_on = [
    module.ekscluster  # 👈 ensures EKS cluster is ACTIVE before node group creation
  ]
}


module "ecr" {
  source               = "./ecr"
  repository_name      = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  scan_on_push         = var.scan_on_push
  ecrtags              = var.ecrtags
}


module "eks_addons" {
  source       = "./eks-addons"
  cluster_name = module.ekscluster.cluster_name

  depends_on = [
    module.ekscluster,
    module.nodegrp
  ]
}
module "jenkins" {
  source       = "./jenkins"

  depends_on = [
    module.ekscluster,
    module.nodegrp,
    module.eks_addons
  ]
}
module "db_secret" {
  source             = "./secretmanager"
  secret_name        = var.db_secret_name
  secret_description = var.db_secret_description
  secret_values      = var.db_secret_values
}

module "redis_secret" {
  source             = "./secretmanager"
  secret_name        = var.redis_secret_name
  secret_description = var.redis_secret_description
  secret_values      = var.redis_secret_values
}