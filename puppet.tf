provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "us-east-1"
}
resource "aws_instance" "puppetdb" {
    ami           = "ami-08842d60"
    instance_type = "t2.micro"
    subnet_id     = "${aws_subnet.database.id}"
    #count         = 2
}
resource "aws_instance" "puppetdb-api" {
    ami           = "ami-08842d60"
    instance_type = "t2.micro"
    subnet_id     = "${aws_subnet.puppet-servers.id}"
    #count         = 2
}
