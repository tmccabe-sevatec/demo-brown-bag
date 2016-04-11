provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-1"
}

variable "cidr_block" {}

resource "aws_vpc" "main" {
    cidr_block = "${var.cidr_block}"

    tags {
        Name = "Demo"
    }
}

resource "aws_subnet" "main" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_block}"

    tags {
        Name = "Main"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "Main IGW"
    }
}

resource "aws_route_table" "r" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "10.0.0.0/24"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Name = "Public Route Table"
    }
}

resource "aws_main_route_table_association" "a" {
    vpc_id = "${aws_vpc.main.id}"
    route_table_id = "${aws_route_table.r.id}"
}
