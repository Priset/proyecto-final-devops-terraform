variable "region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-0e2c8caa4b6378d8c"
}

variable "key_name" {
  description = "Nombre del par de claves SSH"
  type        = string
}
