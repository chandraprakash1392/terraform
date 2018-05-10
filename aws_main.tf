provider "aws" {
    region    = "ap-south-1"
}

resource "aws_vpc" "TerraformVPC" {
    cidr_block   = "${var.vpcCIDRBlock}"
    tags {
        Name = "TestVPC"
    }
}

resource "aws_subnet" "TestPublicSubnet1" {
    vpc_id        = "${aws_vpc.TerraformVPC.id}"
    cidr_block    = "${var.publicsubnet1}"
    availability_zone = "${var.availabilityzone1}"
    tags {
        Name      = "TestPublicSubnet1"    
    }
}

resource "aws_subnet" "TestPublicSubnet2" {
    vpc_id        = "${aws_vpc.TerraformVPC.id}"
    cidr_block    = "${var.publicsubnet2}"
    availability_zone = "${var.availabilityzone2}"
    tags {
        Name      = "TestPublicSubnet2"    
    }
}

# resource "aws_subnet" "TestPrivateSubnet1" {
#     vpc_id         = "${aws_vpc.TerraformVPC.id}"
#     cidr_block     = "${var.privatesubnet1}"
#     availability_zone = "${var.availabilityzone2}"
#     tags {
#         Name       = "TestPrivate1"
#     }
# }

# resource "aws_subnet" "TestPrivateSubnet2" {
#     vpc_id         = "${aws_vpc.TerraformVPC.id}"
#     cidr_block     = "${var.privatesubnet2}"
#     availability_zone = "${var.availabilityzone1}"
#     tags {
#         Name       = "TestPrivate2"
#     }
# }

# resource "aws_eip" "TerraformEIP" {
#     vpc            = true
#     tags {
#         Name       = "TerraformEIP"
#     }
# }
resource "aws_internet_gateway" "TerraformIG" {
    vpc_id         = "${aws_vpc.TerraformVPC.id}"
    tags {
        Name       = "TerraformIG"
    }
}

# resource "aws_nat_gateway" "TerraformNG" {
#     depends_on     = ["aws_internet_gateway.TerraformIG"]
#     allocation_id  = "${aws_eip.TerraformEIP.id}"
#     subnet_id      = "${aws_subnet.TestPublicSubnet1.id}"
#     tags {
#         Name       = "TerraformNG"
#     }
# }

resource "aws_route_table" "PublicRouteTerraform" {
    vpc_id         = "${aws_vpc.TerraformVPC.id}"
    route {
        cidr_block = "${var.destinationCIDRBlock}"
        gateway_id = "${aws_internet_gateway.TerraformIG.id}"
    }
}

# resource "aws_route_table" "PrivateRouteTerraform" {
#     vpc_id          = "${aws_vpc.TerraformVPC.id}"
#     route {
#         cidr_block  = "${var.destinationCIDRBlock}"
#         gateway_id  = "${aws_nat_gateway.TerraformNG.id}"
#     }
# }

resource "aws_route_table_association" "TerraformRouteTableAssocPublic1" {
    subnet_id       = "${aws_subnet.TestPublicSubnet1.id}"
    route_table_id  = "${aws_route_table.PublicRouteTerraform.id}"
}

resource "aws_route_table_association" "TerraformRouteTableAssocPublic2" {
    subnet_id       = "${aws_subnet.TestPublicSubnet2.id}"
    route_table_id  = "${aws_route_table.PublicRouteTerraform.id}"
}

# resource "aws_route_table_association" "TerraformRouteTableAssocPrivate1" {
#     subnet_id       = "${aws_subnet.TestPrivateSubnet1.id}"
#     route_table_id  = "${aws_route_table.PrivateRouteTerraform.id}"
# }

# resource "aws_route_table_association" "TerraformRouteTableAssocPrivate2" {
#     subnet_id       = "${aws_subnet.TestPrivateSubnet2.id}"
#     route_table_id  = "${aws_route_table.PrivateRouteTerraform.id}"
# }

resource "aws_instance" "TerraformPublicInstance1" {
    ami             = "${var.ec2-ami-id}"
    instance_type   = "${var.ec2-size}"
    subnet_id       = "${aws_subnet.TestPublicSubnet1.id}"
    security_groups = ["${aws_security_group.ssh_mobinius.id}", "${aws_security_group.web.id}" ]
    associate_public_ip_address = false
    key_name        = "TerraformTest"
    associate_public_ip_address = true
    tags {
        Name        = "TerraformPublicInstance1"
    }
}

resource "aws_instance" "TerraformPublicInstance2" {
    ami             = "${var.ec2-ami-id}"
    instance_type   = "${var.ec2-size}"
    subnet_id       = "${aws_subnet.TestPublicSubnet2.id}"
    security_groups = ["${aws_security_group.ssh_mobinius.id}", "${aws_security_group.web.id}" ]
    associate_public_ip_address = false
    key_name        = "TerraformTest"
    associate_public_ip_address = true
    tags {
        Name        = "TerraformPublicInstance2"
    }
}

# resource "aws_rds_cluster_instance" "TerraformRDSClusterInstance" {
#     count              = 2
#     identifier         = "${var.rds_cluster_instance_identifier}-${count.index}"
#     cluster_identifier = "${aws_rds_cluster.TerraformRDSCluster.id}"
#     instance_class     = "${var.rds_db_class}"
#     publicly_accessible = false
# }

# resource "aws_rds_cluster" "TerraformRDSCluster" {
#     cluster_identifier = "${var.rds_cluster_identifier}"
#     availability_zones = ["${var.availabilityzone1}", "${var.availabilityzone2}"]
#     skip_final_snapshot = true
#     database_name      = "${var.rds_db_name}"
#     master_username    = "${var.rds_username}"
#     master_password    = "${var.rds_password}"
# }

resource "aws_alb" "WebServerLB" {
    name               = "TerraformLBWeb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = ["${aws_security_group.web.id}"]
    subnets            = ["${aws_subnet.TestPublicSubnet1.id}", "${aws_subnet.TestPublicSubnet2.id}"]
}

resource "aws_lb_target_group" "WebServer" {
    name               = "WebServerTG"
    port               = 80
    protocol           = "HTTP"
    vpc_id             = "${aws_vpc.TerraformVPC.id}"
}

resource "aws_lb_target_group_attachment" "WebServer1" {
    target_group_arn   = "${aws_lb_target_group.WebServer.arn}"
    target_id          = "${aws_instance.TerraformPublicInstance1.id}"
    port               = 80
}

resource "aws_lb_target_group_attachment" "WebServer2" {
    target_group_arn   = "${aws_lb_target_group.WebServer.arn}"
    target_id          = "${aws_instance.TerraformPublicInstance2.id}"
    port               = 80
}

resource "aws_lb_listener" "WebServer" {
    load_balancer_arn  = "${aws_alb.WebServerLB.arn}"
    port               = 80
    protocol           = "HTTP"
    default_action {
        target_group_arn = "${aws_lb_target_group.WebServer.arn}"
        type           = "forward"
    }
}