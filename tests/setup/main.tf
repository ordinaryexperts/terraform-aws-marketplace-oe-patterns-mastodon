terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

resource "random_pet" "stack_prefix" {}

output "stack_prefix" {
  value = random_pet.stack_prefix.id
}
