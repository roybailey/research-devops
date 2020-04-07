provider "aws" {
  region = var.aws_region
}

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
# network access control lists

resource "aws_default_network_acl" "dc1_acl_default" {
  default_network_acl_id = aws_vpc.dc1.default_network_acl_id

  ingress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = aws_vpc.dc1.cidr_block
    from_port = 0
    to_port = 0
  }

  egress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  subnet_ids = [
    aws_subnet.dc1_az1_sn11_private.id,
    aws_subnet.dc1_az2_sn12_private.id
  ]

  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-acl-default"
  }
}

resource "aws_network_acl" "dc1_acl_public" {
  vpc_id = aws_vpc.dc1.id

  ingress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  ingress {
    protocol = -1
    rule_no = 100
    action = "allow"
    ipv6_cidr_block = "::/0"
    from_port = 0
    to_port = 0
  }

  egress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  egress {
    protocol = -1
    rule_no = 100
    action = "allow"
    ipv6_cidr_block = "::/0"
    from_port = 0
    to_port = 0
  }

  subnet_ids = [
    aws_subnet.dc1_az1_sn1_public.id,
    aws_subnet.dc1_az2_sn2_public.id
  ]

  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-acl-public"
  }
}

# ------------------------------------------------------------
# security groups

resource "aws_default_security_group" "dc1_sg_default" {
  vpc_id = aws_vpc.dc1.id
  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-sg-default"
  }
}

resource "aws_security_group" "dc1_sg_web" {
  name = "http-https-allow"
  description = "Allow incoming HTTP and HTTPS and Connections"
  vpc_id = aws_vpc.dc1.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "51.9.163.117/32"
    ]
  }

  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-sg-web"
  }
}

# ------------------------------------------------------------
# ec2 instances

resource "aws_instance" "dc1_web_server" {

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = lookup(var.aws_amis, var.aws_region)

  # The name of our SSH keypair we created above.
  key_name = var.key_name

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = aws_subnet.dc1_az1_sn1_public.id

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [
    aws_security_group.dc1_sg_web.id
  ]

  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ec2-user"
    private_key = file(var.key_file)
    host = self.public_ip
    # The connection will use the local SSH agent for authentication.
  }

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo service nginx start",
    ]
  }

  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-ec2-web"
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

# ------------------------------------------------------------
# outputs

output "dc1_out" {
  value = "${aws_vpc.dc1.tags.Name}=${aws_vpc.dc1.id}"
}
output "azs_out" {
  value = data.aws_availability_zones.azs
}

output "igw_out" {
  value = "${aws_internet_gateway.dc1_igw.tags.Name}=${aws_internet_gateway.dc1_igw.id}"
}

output "sn1_out" {
  value = "${aws_subnet.dc1_az1_sn1_public.tags.Name}=${aws_subnet.dc1_az1_sn1_public.id}"
}
output "sn2_out" {
  value = "${aws_subnet.dc1_az2_sn2_public.tags.Name}=${aws_subnet.dc1_az2_sn2_public.id}"
}
output "sn11_out" {
  value = "${aws_subnet.dc1_az1_sn11_private.tags.Name}=${aws_subnet.dc1_az1_sn11_private.id}"
}
output "sn12_out" {
  value = "${aws_subnet.dc1_az2_sn12_private.tags.Name}=${aws_subnet.dc1_az2_sn12_private.id}"
}
