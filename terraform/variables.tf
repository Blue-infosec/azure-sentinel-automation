variable "rg" {
  type = map
  default = {
    name = "secopslab-resources"
    location = "North Europe"
  }
}

variable "law" {
  type = map
  default = {
     name = "secopslab-laworkspace"
     sku = "PerGB2018"
     retention = "90"
   }
}

variable "rbac" {
  type = map
    default = {
      aad_group_id_sentinel_contributors = "xx-xx-xx-xx-xx"
      aad_group_id_sentinel_responders = "xx-xx-xx-xx-xx"
      aad_group_id_sentinel_readers = "xx-xx-xx-xx-xx"
    }
}
