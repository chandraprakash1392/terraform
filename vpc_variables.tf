variable "availabilityzone1" {
    default = "ap-south-1a"
}

variable "availabilityzone2" {
    default = "ap-south-1b"
}

variable "vpcCIDRBlock" {
    default = "99.99.0.0/16"
}

variable "publicsubnet1" {
    default = "99.99.1.0/24"
}

variable "publicsubnet2" {
    default = "99.99.2.0/24"
}

variable "privatesubnet1" {
    default = "99.99.3.0/24"
}

variable "privatesubnet2" {
    default = "99.99.4.0/24"
}

variable "destinationCIDRBlock" {
    default = "0.0.0.0/0"
}
