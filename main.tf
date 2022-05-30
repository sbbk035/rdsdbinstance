provider "aws" {
    region              = "ap-south-1"
    profile             = "bharath"
}

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "My VPC"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Subnet2"
  }
}

resource "aws_db_subnet_group" "subnetgroups" {
  name       = "privatesubnets"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_security_group" "sg1" {
  name        = "allow_all_traffic"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "All Traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "MYSQL"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_traffic"
  }
}

resource "aws_db_instance" "mysql-db" {
  identifier                            = "mysqldatabase"
  allocated_storage                     = 20
  engine                                = "mysql"
  engine_version                        = "8.0.27"
  instance_class                        = "db.t3.micro"
  name                                  = "rds_mysqldb"
  username                              = var.username
  password                              = var.password
  parameter_group_name                  = "default.mysql8.0"
  db_subnet_group_name                  = "${aws_db_subnet_group.subnetgroups.id}"
  publicly_accessible                   = false
  skip_final_snapshot                   = true
  vpc_security_group_ids                = ["${aws_security_group.sg1.id}"]
  storage_encrypted                     = true

  tags = {
      name                              = "MySQL RDS DB Instance"
  }

}

