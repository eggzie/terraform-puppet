# Bastion
resource "aws_security_group" "bastion" {
    name        = "bastion"
    description = "Allow SSH traffic from the internet"
    vpc_id      = "${aws_vpc.tf-puppet.id}"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "bastion" {
    ami               = "ami-08842d60"
    instance_type     = "t2.micro"
    key_name          = "${var.key_name}"
    security_groups   = ["${aws_security_group.bastion.id}"]
    subnet_id         = "${aws_subnet.puppet-servers.id}"
}
resource "aws_eip" "bastion" {
    instance = "${aws_instance.bastion.id}"
    vpc      = true
}
