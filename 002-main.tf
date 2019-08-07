


module "webserver_cluster" {
  source = "./modules/services/webserver-cluster"

  server_port = 8080

  namespace   = "skcc"
  stage       = "dev"
  name        = "helloApp"
  delimiter   = "-"
  tags = {
        "Company"    = "SK GAS"
        "Department" = "Unit1"
        "User"       = "jingood2@sk.com"
  }
}








