variable "hcloud_token" {
  type        = string
  description = "API token generated using the Hetzner Cloud Console."
}

variable "location" {
  type        = string
  description = "The location to provision the servers in (nbg1, fsn1 or hel1)."

  validation {
    condition     = contains(["nbg1", "fsn1", "hel1"], var.location)
    error_message = "Valid values for location are nbg1, fsn1 or hel1."
  } 
}

variable "workers" {
  type        = number
  description = "The number of worker nodes to provision."
}
