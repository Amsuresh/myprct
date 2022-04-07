variable "vpc_cidr" {
	type=string
}
resource "aws_vpc" "vpc1" {
	cidr_block = var.vpc_cidr
	tags = {
	"name" = "vpc1"
	}
}
variable "v_azs"{
	}
variable "pub_sn_cidrs" {
	type=list
	
}
variable "prv_sn_cidrs" {
	type=list
	
}	
resource "aws_subnet" "pub_sn" {
  count=length(var.pub_sn_cidrs)
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.pub_sn_cidrs[count.index]
  availability_zone= var.v_azs[count.index]
}
resource "aws_subnet" "prv_sn" {
  count=length(var.prv_sn_cidrs)
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.prv_sn_cidrs[count.index]
  availability_zone= var.v_azs[count.index]
}
resource "aws_internet_gateway" "igw1" {
vpc_id     = aws_vpc.vpc1.id
}
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0
    gateway_id = aws_internet_gateway.igw1.id
  }
 resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub_sn.id
  route_table_id = aws_route_table.rt1.id
}