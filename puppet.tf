provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "us-east-1"
}
resource "aws_instance" "puppetdb" {
    ami           = "ami-408c7f28"
    instance_type = "t1.micro"
    count         = 2
}
