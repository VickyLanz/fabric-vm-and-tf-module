module "vpc" {
  source ="terraform-google-modules/network/google//modules/vpc"
  network_name = var.mnetwork_name
  project_id   = var.mproject_id
  mtu = var.mmtu
  auto_create_subnetworks = var.mauto_create_subnetworks

}

module "subnet" {
  source = "terraform-google-modules/network/google//modules/subnets"
  depends_on = [module.vpc]

  network_name = module.vpc.network_name
  project_id   = var.mproject_id
  subnets      = [{
    subnet_name=var.msubnet_name
    subnet_ip="10.128.0.0/20"
    subnet_region="us-central1"
  }]
}

module "fire_wall_rules" {
  source = "terraform-google-modules/network/google//modules/firewall-rules"
  depends_on = [module.vpc]

  network_name = module.vpc.network_name
  project_id   = var.mproject_id
  rules = [{
    name = "custom-allow-ssh"
    direction = "INGRESS"
    ranges =["0.0.0.0/0"]
    allow=[{
      protocol="tcp"
      ports=["22"]
    }]
    deny=[]
    description=null
    log_config={
      metadata="INCLUDE_ALL_METADATA"
    }
    priority=null
    source_service_accounts=null
    source_tags=null
    target_service_accounts=null
    target_tags=null


  },
    {
      name = "custom-allow-ping"
      direction="INGRESS"
      ranges=["0.0.0.0/0"]
      allow=[{
        protocol="icmp"
        ports=null
      }]
      deny=[]
    description=null
    log_config={
      metadata="INCLUDE_ALL_METADATA"
    }
    priority=null
    source_service_accounts=null
    source_tags=null
    target_service_accounts=null
    target_tags=null
    },
    {
      name="custom-allow-rdp"
      direction="INGRESS"
      ranges=["0.0.0.0/0"]
      allow=[{
        protocol="tcp"
        ports=["3389"]
      }]
      deny=[]
    description=null
    log_config={
      metadata="INCLUDE_ALL_METADATA"
    }
    priority=null
    source_service_accounts=null
    source_tags=null
    target_service_accounts=null
    target_tags=null
    },
    {
      name="custom-allow-internal"
      direction="INGRESS"
      ranges=["0.0.0.0/0"]
      allow=[{
        protocol="tcp"
        ports=["0-65535"]
      },
        {
          protocol="udp"
          ports=["0-65535"]
        },
        {
          protocol="icmp"
          ports=null
        }]
      deny=[]
    description=null
    log_config={
      metadata="INCLUDE_ALL_METADATA"
    }
    priority=null
    source_service_accounts=null
    source_tags=null
    target_service_accounts=null
    target_tags=null
    }]

}
data "google_compute_subnetwork" "my-subnetwork" {
  depends_on = [module.subnet]
  name   = var.msubnet_name
  region = var.mregion
  project = var.mproject_id
}
module "compute_vm" {
  depends_on = [module.subnet]
  source = "../module"
   tags = ["http-server","https-server"]
  labels = {
    env="prod",
    name="infor"
  }
  metadata = {
    startup-script="${file(var.mpath)}"
  }

  name = "custom-instance"
  network_interfaces = [{
    network =module.vpc.network_self_link
    subnetwork =data.google_compute_subnetwork.my-subnetwork.self_link
    nat=true
    addresses=null
  }]
  project_id         = var.mproject_id
  zone               = var.mzone
}