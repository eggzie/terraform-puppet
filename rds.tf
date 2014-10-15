/*
resource "aws_db_security_group" "puppetdb-postgres" {
    name        = "RDS Security Group for DB"
    description = "RDS Security Group for PuppetDB PostGres"
    ingress     =  { cidr = "10.0.0.0/16" }
}
resource "aws_db_instance" "puppetdb-postgres" {
    identifier        = "puppetdb-postgres"
    allocated_storage = 10
    engine            = "postgres"
    engine_version    = "9.3.3"
    instance_class    = "db.t1.micro"
    name              = "puppetdb"
    username          = "puppetdb"
    password          = "puppetdb"
    security_group_names = ["${aws_db_security_group.puppetdb-postgres.name}"]
}
*/
