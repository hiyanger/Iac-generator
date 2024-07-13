# 変数nameをstringで設定する
variable "name" {
    type = string
}

# amazonqというVPCを作成する。CIDRを設定する。nameタグにnameを設定する。
resource "aws_vpc" "iacgenerator" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "${var.name}"
    }
}

# amazonqというVPCにインターネットゲートウェイを作成する。nameタグにnameを設定する。
resource "aws_internet_gateway" "iacgenerator" {
    vpc_id = aws_vpc.iacgenerator.id
    tags = {
        Name = "${var.name}"
    }
}

# amazonqというVPCにサブネットを作成する。nameタグにnameを設定する。
resource "aws_subnet" "iacgenerator" {
    vpc_id = aws_vpc.iacgenerator.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "${var.name}"
    }
}

# ルートテーブルを作成する。nameタグにnameを設定する。
resource "aws_route_table" "iacgenerator" {
    vpc_id = aws_vpc.iacgenerator.id
    tags = {
        Name = "${var.name}"
    }
}

# ルートテーブルにインターネットゲートウェイを紐づける
resource "aws_route" "iacgenerator" {
    route_table_id = aws_route_table.iacgenerator.id
    gateway_id = aws_internet_gateway.iacgenerator.id
    destination_cidr_block = "0.0.0.0/0"
}

# サブネットにルートテーブルを紐付ける。
resource "aws_route_table_association" "iacgenerator" {
    subnet_id = aws_subnet.iacgenerator.id
    route_table_id = aws_route_table.iacgenerator.id
}

