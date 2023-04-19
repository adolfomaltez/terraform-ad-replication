resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.10.0.0/16"
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    instance_tenancy = "default"    
    
    tags = {
        Name = "VPC-Grupo4"
    }
}

resource "aws_subnet" "prod-subnet-us" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.10.10.0/24"
    map_public_ip_on_launch = "true" #it makes this a public subnet
    availability_zone = "us-east-1a"

    tags = {
        Name = "Subnet-US"
    }
}

resource "aws_subnet" "prod-subnet-uk" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.10.20.0/24"
    map_public_ip_on_launch = "true" #it makes this a public subnet
    availability_zone = "us-east-1b"

    tags = {
        Name = "Subnet-UK"
    }
}