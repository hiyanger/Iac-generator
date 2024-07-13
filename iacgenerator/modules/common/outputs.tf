# VPCIDを出力する
output "vpc_id" {
    value = aws_vpc.iacgenerator.id
}

# サブネットIDを出力する
output "subnet_id" {
    value = aws_subnet.iacgenerator.id
}

