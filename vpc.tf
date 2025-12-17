module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~>13.0"

  project_id   = var.project_id
  network_name = "fixmate-vpc"

  subnets = [
    {
      subnet_name           = "fixmate-subnet"
      subnet_ip             = "10.10.0.0/16"
      subnet_region         = var.region
      subnet_private_access = true
      description           = "Subnet for Fixmate application"

      subnet_labels = {
        app = "fixmate"
        env = "dev"
      }
    }
  ]

  secondary_ranges = {
    "fixmate-subnet" = [
      {
        range_name    = "pods"
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = "services"
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }

}