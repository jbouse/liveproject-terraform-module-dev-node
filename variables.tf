variable "admin_cidr" {
  description = "Admin desktop CIDR to allow"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "rhsm_org" {
  description = "RedHat Subscription Manager Org ID"
  type        = number
}

variable "rhsm_key" {
  description = "RedHat Subscription Manager activatation key to register host"
  type        = string
}