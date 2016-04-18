# VPC
resource "aws_vpc" "tf-puppet" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = "true"
}
resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.tf-puppet.id}"
}
# DB subnet
resource "aws_subnet" "database" {
    vpc_id     = "${aws_vpc.tf-puppet.id}"
    cidr_block = "10.0.2.0/24"
}
# Puppet server subnet
resource "aws_subnet" "puppet-servers" {
    vpc_id     = "${aws_vpc.tf-puppet.id}"
    cidr_block = "10.0.1.0/24"
}

# Routing table for public subnets
resource "aws_route_table" "puppet-public" {
    vpc_id = "${aws_vpc.tf-puppet.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}
resource "aws_route_table_association" "puppet-servers-public" {
    subnet_id      = "${aws_subnet.puppet-servers.id}"
    route_table_id = "${aws_route_table.puppet-public.id}"
}

# Routing table for private subnets
resource "aws_route_table" "puppet-private" {
    vpc_id = "${aws_vpc.tf-puppet.id}"
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.gw.id}"
    }
}
resource "aws_route_table_association" "puppet-private" {
    subnet_id      = "${aws_subnet.database.id}"
    route_table_id = "${aws_route_table.puppet-private.id}"
}

# NAT
resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id     = "${aws_subnet.puppet-servers.id}"
    depends_on    = ["aws_internet_gateway.gw"]
}
resource "aws_eip" "nat" {
        vpc      = true
}
# resource "aws_instance" "nat" {
#    ami                         = "${var.nat_ami}"
#    instance_type               = "m1.small"
#    key_name                    = "${var.key_name}"
#    security_groups             = ["${aws_security_group.nat.id}"]
#    subnet_id                   = "${aws_subnet.database.id}"
#    associate_public_ip_address = true
#    source_dest_check           = false
#}

resource "aws_security_group" "nat" {
    name        = "nat"
    description = "Allow services from the private subnet through NAT"
    vpc_id      = "${aws_vpc.tf-puppet.id}"
    ingress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["${aws_subnet.database.cidr_block}"]
    }
    ingress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["${aws_subnet.puppet-servers.cidr_block}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
