resource "aws_iam_user" "s3_user" {
    name = "cc-midterm-s3-user"
    tags = {
        Name = "cc-midterm-s3-full-access-user"
    }
}

resource "aws_iam_user_policy_attachment" "s3_user_attachment" {
    user = aws_iam_user.s3_user.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_access_key" "s3_user" {
    user = aws_iam_user.s3_user.name
}
