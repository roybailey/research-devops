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
