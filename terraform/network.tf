# AWS Availability Zones data
data "aws_availability_zones" "available" {}

# Criar a vpc
resource "aws_vpc" "redshift-vpc" {
    cidr_block = var.redshift_vpc_cidr
    enable_dns_hostnames = true
}

# Criar a Redshift subnet AZ1
resource "aws_subnet" "redshift-subnet-az1" {
    vpc_id = aws_vpc.redshift-vpc.id
    cidr_block = var.redshift_subnet_1_cidr
    availability_zone = data.aws_availability_zones.available.names[0]
}

# Criar a Redshift subnet AZ2
resource "aws_subnet" "redshift-subnet-az2" {
    vpc_id = aws_vpc.redshift-vpc.id
    cidr_block = var.redshift_subnet_2_cidr
    availability_zone = data.aws_availability_zones.available.names[1]
}

# Criar grupo de subnet redshift
resource "aws_redshift_subnet_group" "redshift-subnet-group" {
    depends_on = [
      aws_subnet.redshift-subnet-az1,
      aws_subnet.redshift-subnet-az2,
    ]

    name = "simple-dw-redshift-subnet-group"
    subnet_ids = [aws_subnet.redshift-subnet-az1.id, aws_subnet.redshift-subnet-az2.id]
}

# Internet Gateway
resource "aws_internet_gateway" "redshift-igw" {
    vpc_id = aws_vpc.redshift-vpc.id
}

# Define the Redshift route table to Internet Gataway
resource "aws_route_table" "redshift-rt-igw" {
    vpc_id = aws_vpc.redshift-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.redshift-igw.id
    }
}

# Assign the redshift route table to the redshift subnet az1 for IGW
resource "aws_route_table_association" "redshift-subnet-rt-association-igw-az1" {
    subnet_id = aws_subnet.redshift-subnet-az1.id
    route_table_id = aws_route_table.redshift-rt-igw.id
}

# Assign the redshift route table to the redshift subnet az2 for IGW
resource "aws_route_table_association" "redshift-subnet-rt-association-igw-az2" {
    subnet_id = aws_subnet.redshift-subnet-az2.id
    route_table_id = aws_route_table.redshift-rt-igw.id
}
