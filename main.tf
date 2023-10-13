terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "spark_task_deserialization_failures" {
  source    = "./modules/spark_task_deserialization_failures"

  providers = {
    shoreline = shoreline
  }
}