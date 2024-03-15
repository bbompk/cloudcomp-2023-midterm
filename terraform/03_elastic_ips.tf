resource "aws_eip" "nat" {
  tags = {
    Name = "cc-midterm-nat-eip"
  }
}

resource "aws_eip" "wp_server" {
  tags = {
    Name = "cc-midterm-wordpress-eip"
  }
}