resource "aws_security_group" "default" {
    name        = "cc-midterm-default-sg"
    description = "Allow all traffic within the VPC"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "cc-midterm-default-sg"
    }
}

resource "aws_security_group" "wp_server" {
    name        = "cc-midterm-wordpress-sg"
    description = "Allow inbound traffic to WordPress server"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "cc-midterm-wp-server-sg"
    }
}

resource "aws_security_group" "db_server" {
    name        = "cc-midterm-db-sg"
    description = "Allow inbound traffic to database server only from WordPress server"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.wp_server.id]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = [aws_security_group.wp_server.id]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        security_groups = [aws_security_group.wp_server.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "cc-midterm-db-server-sg"
    }
}
