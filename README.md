# terraform
AWS Infrastructure automation end to end

Steps to perform before using this script:
1. Install aws cli
2. Perform the "aws configure" command
3. Download terraform latest version

-> aws_main.tf is the main terraform code

-> ec2_instance.tf is the config file for your ec2_instances

-> TerraformTestKey.tf is the config file where you need to place your public key and PemFile name

-> vpc_variables.tf is the configuration settings for your VPC containing the CIDR block, subnets, availability zones etc.

-> security_groups.tf is the configuration settings for the security_groups you want to include in your EC2 Instances
