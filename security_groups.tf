resource "aws_security_group" "ssh_mobinius" {
    name         = "ssh_access_mobinius"
    description  = "SSH Access only from Mobinius Infra"
    vpc_id       = "${aws_vpc.TerraformVPC.id}"
    ingress {
        from_port = "22"
        to_port   = "22"
        protocol  = "tcp"
        cidr_blocks = ["106.51.231.38/32"]
    }
    egress { 
        from_port  = "0"
        to_port    = "65535"
        protocol   = "tcp"
        cidr_blocks = ["${var.destinationCIDRBlock}"]
    }
}

resource "aws_security_group" "web" {
    name           = "WebAccess"
    description    = "Web application access"
    vpc_id         = "${aws_vpc.TerraformVPC.id}"
    ingress {
        from_port  = 80
        to_port    = 80
        protocol   = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port  = "0"
        to_port    = "65535"
        protocol   = "tcp"
        cidr_blocks = ["${var.destinationCIDRBlock}"]
    }
}