provider "aws" {
  region = var.aws_region
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
    rule_no = 101
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
    rule_no = 101
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

  ingress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [
      aws_vpc.dc1.cidr_block
    ]
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-sg-default"
  }
}

resource "aws_security_group" "dc1_sg_web" {
  name = "http-https-allow"
  description = "Allow incoming HTTP and HTTPS and Connections"
  vpc_id = aws_vpc.dc1.id

  ingress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
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
    timeout = "1m"
  }

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    script = "dc1_web_server.sh"
  }

  tags = {
    Name = "${aws_vpc.dc1.tags.Name}-ec2-web"
  }
}
