## Subnet 1 creation

resource "aws_subnet" "myapp-subnet1" {

  cidr_block        = var.subnet1_cidr_block
  vpc_id            = var.vpc_id
  availability_zone = var.az1
  tags = {
    "Name" = "${var.env_prefix}-subnet1"
  }

}

## Subnet 2 creation for HA 


resource "aws_subnet" "myapp-subnet2" {

  cidr_block        = var.subnet2_cidr_block
  vpc_id            = var.vpc_id
  availability_zone = var.az2
  tags = {
    "Name" = "${var.env_prefix}-subnet2"
  }

}


## Internet Gateway creation

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id
  tags = {
    "Name" = "${var.env_prefix}-igw"
  }

}

## route table creation

resource "aws_route_table" "myapp-rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    "Name" = "${var.env_prefix}-rt"
  }

}

## Route table association with subnet 1

resource "aws_route_table_association" "myapp-rt-asso-subnet1" {
  subnet_id      = aws_subnet.myapp-subnet1.id
  route_table_id = aws_route_table.myapp-rt.id

}


resource "aws_route_table_association" "myapp-rt-asso-subnet2" {
  subnet_id      = aws_subnet.myapp-subnet2.id
  route_table_id = aws_route_table.myapp-rt.id

}
