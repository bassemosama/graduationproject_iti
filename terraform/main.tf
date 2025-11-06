module "myvpc" {
  source   = "./vpc"
  vpc_cidr = var.vpc_cidr
  tags     = var.tags

}
 module "publicsubnet" {
  count=length(var.subnet-cidr)  
  source = "./publicsubnets"
  vpc_id = module.myvpc.vpc_id
  subnet-cidr = var.subnet-cidr[count.index]
  azs = var.azs[count.index]
  tags     = var.tags
}
module "privatesubnet" {
  count=length(var.privatesubnet-cidr)  
  source = "./privatesubnets"
  vpc_id = module.myvpc.vpc_id
  subnet-cidr = var.privatesubnet-cidr[count.index]
  azs = var.azs[count.index]
  tags     = var.tags
}
 module "myigw" {
  source = "./igw"
  thevpc_id = module.myvpc.vpc_id   
  tags     = var.tags 
  }
  module "natgateway" {
  source = "./natgw"
  public_subnet_id = module.publicsubnet[0].subnet_id
  tags     = var.tags
}
module "privateroutetable" {
  source = "./privateroutetable"
  vpc_id = module.myvpc.vpc_id
  natgateway_id = module.natgateway.mynategaway_id
  tags     = var.tags
}
module "publicroutetable" {
  source = "./publicroutetable"
  vpc_id = module.myvpc.vpc_id
  igw_id = module.myigw.inetnetgateway_id
  tags     = var.tags

}
module "publictableassociation" {
  count=length(var.subnet-cidr)  
  source = "./publictableasso"
  subnet_id = module.publicsubnet[count.index].subnet_id
  route_table_id = module.publicroutetable.public_route_table_id
}
module "privatetableassociation" {
  count=length(var.privatesubnet-cidr)  
  source = "./privatetableasso"
  subnet_id = module.privatesubnet[count.index].privatesubnet_id
  route_table_id = module.privateroutetable.private_route_table_id
}

module "ekscluster" {
  source = "./ekscluster"
  cluster_name = var.cluster_name
  subnet_ids = [
  module.privatesubnet[0].privatesubnet_id,
  module.privatesubnet[1].privatesubnet_id,
  module.privatesubnet[2].privatesubnet_id
]
  tags     = var.tags
  eks_version = var.eks_version
}

module "nodegrp" {
  source = "./nodegrp"
  cluster_name = var.cluster_name
  subnet_ids = [
  module.privatesubnet[0].privatesubnet_id,
  module.privatesubnet[1].privatesubnet_id,
  module.privatesubnet[2].privatesubnet_id
]
}
module "ecr" {
  source           = "./ecr"
  repository_name  = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  scan_on_push     = var.scan_on_push
  ecrtags          = var.ecrtags
}

