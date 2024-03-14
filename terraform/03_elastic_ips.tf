resource "aws_elastic_ip" "nat" {
  vpc = true

  tags = {
    Name = "cc-midterm-nat-eip"
  }
}

resource "aws_elastic_ip" "wp_server" {
  vpc = true

  tags = {
    Name = "cc-midterm-wordpress-eip"
  }
}