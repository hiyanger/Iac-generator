# AWSプロバイダを設定する
provider "aws" {
    region = "ap-northeast-1"
}

# iacgenerator0628というバケット名のS3にtfstateを配置する
terraform {
    backend "s3" {
        bucket = "XXXX" # 補完する
        key    = "tfstate"
        region = "ap-northeast-1"
    }
}

# 変数nameにdefault値でiacgeneratorを格納する。型も設定する。
variable "name" {
    type = string
    default = "iacgenerator"
}

# moduleのcommonを取得する
module "common" {
    source = "./modules/common"
    name = var.name
}

# iacgeneratorというセキュリティグループを作成する。SSHを許可する。タグに変数nameを設定する。VPCをmodulesから取得する。
resource "aws_security_group" "iacgenerator" {
    name = var.name
    vpc_id = module.common.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["XXX.XXX.XXX.XXX/32"] # 補完する
    }
    tags = {
        Name = var.name
    }
}

# iacgeneratorというEC2作成する。iacgeneratorというセキュリティグループに紐づける。パブリックIPを付与する。iacgeneratorというキーペアを使う。Nameタグを変数nameにする。
resource "aws_instance" "iacgenerator" {
    instance_type = "t2.micro"
    ami = "ami-061a125c7c02edb39"
    key_name = "iacgenerator" # コンソールでで先に作っておく
    vpc_security_group_ids = [aws_security_group.iacgenerator.id]
    associate_public_ip_address = true
    subnet_id = module.common.subnet_id
    tags = {
        Name = var.name
    }
}