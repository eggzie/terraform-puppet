provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "us-east-1"
}
resource "aws_instance" "puppetdb" {
    ami             = "ami-08842d60"
    instance_type   = "t2.micro"
    subnet_id       = "${aws_subnet.database.id}"
    security_groups = ["${aws_security_group.4_db_servers.id}"]
    key_name        = "${var.key_name}"
    count           = 1
    tags {
        Name = "Puppetdb"
    }
}
/*
resource "aws_instance" "puppetdb-api" {
    ami             = "ami-08842d60"
    instance_type   = "t2.micro"
    subnet_id       = "${aws_subnet.puppet-servers.id}"
    security_groups = ["${aws_security_group.4_puppet_servers.id}"]
    key_name        = "${var.key_name}"
    count           = 1
    associate_public_ip_address = "True"
    tags {
        Name = "Puppet-API"
    }
}
*/
resource "aws_instance" "puppetmaster" {
    ami             = "ami-08842d60"
    instance_type   = "t2.micro"
    subnet_id       = "${aws_subnet.puppet-servers.id}"
    security_groups = ["${aws_security_group.4_puppet_servers.id}"]
    key_name        = "${var.key_name}"
    count           = 1
    user_data       = "${file("puppet_client.sh")}" 
    associate_public_ip_address = "True"
    tags {
        Name = "PuppetMaster"
    }
}
resource "aws_security_group" "4_db_servers" {
    name        = "4_db_servers"
    description = "security group to apply to DB servers"
    vpc_id      = "${aws_vpc.tf-puppet.id}"
    ingress {
        self            = true
        from_port       = "22"
        to_port         = "22"
        protocol        = "tcp"
        security_groups = ["${aws_security_group.bastion.id}"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "4_puppet_servers" {
    name        = "4_puppet_servers"
    description = "security group to apply to puppetdb and master servers"
    vpc_id      = "${aws_vpc.tf-puppet.id}"
    ingress {
        self            = true
        from_port       = "22"
        to_port         = "22"
        protocol        = "tcp"
        security_groups = ["${aws_security_group.bastion.id}"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
