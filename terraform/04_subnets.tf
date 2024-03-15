resource "aws_subnet" "public_wp" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.16/28"
    availability_zone = var.availability_zone

    tags = {
        Name = "cc-midterm-public-wp"
    }
}

resource "aws_subnet" "public_nat" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.32/28"
    availability_zone = var.availability_zone

    tags = {
        Name = "cc-midterm-public-nat"
    }
}

resource "aws_subnet" "private_wp_db" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.48/28"
    availability_zone = var.availability_zone

    tags = {
        Name = "cc-midterm-private-wp-db"
    }
}

resource "aws_subnet" "private_db_nat" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/28"
    availability_zone = var.availability_zone

    tags = {
        Name = "cc-midterm-private-db-nat"
    }
}