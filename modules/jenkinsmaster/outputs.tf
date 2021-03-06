# elastic ip output
output "eip_id" {
  value = "${aws_eip.lb.id}"
}

# securty group output
output "sgrp_id" {
  value = "${aws_security_group.allow_all.id}"
}
# output the key so we use the same one for all machines
output "key_name" {
  value = "${aws_key_pair.my-key.key_name}"
}
output "eip_dns" {
  value = "${aws_eip.lb.public_dns}"
}
