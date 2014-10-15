resource "aws_vpc" "tf-puppet" {
    cidr_block = "10.0.0.0/16"
}
resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.tf-puppet.id}"
}
resource "aws_subnet" "db_net" {
    vpc_id = "${aws_vpc.tf-puppet.id}"
    cidr_block = "10.0.1.0/24"
}
resource "aws_subnet" "puppetdb_net" {
    vpc_id = "${aws_vpc.tf-puppet.id}"
    cidr_block = "10.0.2.0/24"
}
