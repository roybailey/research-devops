variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "roybaileybiz-n-virginia"
}

variable "key_file" {
  description = "Private key to ssh into box"
  default = "/Users/roybailey/.aws/kp-nvirgina.pem"
}

# Amazon Linux
variable "aws_amis" {
  default = {
    us-east-1 = "ami-0fc61db8544a617ed"
  }
}

