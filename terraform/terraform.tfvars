vpc_cidr              = "10.0.0.0/16"
subnet-cidr           = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
privatesubnet-cidr    = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
azs                   = ["us-east-1a", "us-east-1b", "us-east-1c"]
db_secret_name        = "db-secret-test"
db_secret_description = "Database credentials for NodeJS app"
db_secret_values = {
  DB_USER     = "root"
  DB_PASSWORD = "pass123"
  DB_HOST     = "db-cluster.mysql-operator.svc.cluster.local"
  DB_PORT     = "6450"
}

redis_secret_name        = "redis-secret-test"
redis_secret_description = "Redis connection details"
redis_secret_values = {
  REDIS_HOST = "redis-service"
  REDIS_PORT = "6379"
}
