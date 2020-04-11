# ------------------------------------------------------------
# create a vpc
resource "aws_vpc" "dc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf-dc1"
  }
}

# gets all availability zones that are available in region into var 'azs'
data "aws_availability_zones" "azs" {
  state = "available"
}

# ------------------------------------------------------------
# create internet gateway

resource "aws_internet_gateway" "dc1_igw" {
  vpc_id = aws_vpc.dc1.id
  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-igw"
  }
}

# ------------------------------------------------------------
# create public subnets

resource "aws_subnet" "dc1_az1_sn1_public" {
  availability_zone = data.aws_availability_zones.azs.names[0]
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.dc1.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-sn-10.0.1.0"
  }
}

resource "aws_subnet" "dc1_az2_sn2_public" {
  availability_zone = data.aws_availability_zones.azs.names[1]
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.dc1.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-sn-10.0.2.0"
  }
}

# ------------------------------------------------------------
# create private subnets

resource "aws_subnet" "dc1_az1_sn11_private" {
  availability_zone = data.aws_availability_zones.azs.names[0]
  cidr_block = "10.0.11.0/24"
  vpc_id = aws_vpc.dc1.id
  map_public_ip_on_launch = false
  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-sn-10.0.11.0"
  }
}

resource "aws_subnet" "dc1_az2_sn12_private" {
  availability_zone = data.aws_availability_zones.azs.names[1]
  cidr_block = "10.0.12.0/24"
  vpc_id = aws_vpc.dc1.id
  map_public_ip_on_launch = false
  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-sn-10.0.12.0"
  }
}

# ------------------------------------------------------------
# route tables and routes

resource "aws_route_table" "dc1_route_public" {
  vpc_id = aws_vpc.dc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dc1_igw.id
  }

  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-route-public"
  }
}

resource "aws_default_route_table" "dc1_route_private" {
  default_route_table_id = aws_vpc.dc1.default_route_table_id

  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-route-private"
  }
}

# ------------------------------------------------------------
# associations

resource "aws_route_table_association" "art1" {
  subnet_id = aws_subnet.dc1_az1_sn1_public.id
  route_table_id = aws_route_table.dc1_route_public.id
}

resource "aws_route_table_association" "art2" {
  subnet_id = aws_subnet.dc1_az2_sn2_public.id
  route_table_id = aws_route_table.dc1_route_public.id
}

resource "aws_route_table_association" "art11" {
  subnet_id = aws_subnet.dc1_az1_sn11_private.id
  route_table_id = aws_default_route_table.dc1_route_private.id
}

resource "aws_route_table_association" "art12" {
  subnet_id = aws_subnet.dc1_az2_sn12_private.id
  route_table_id = aws_default_route_table.dc1_route_private.id
}

