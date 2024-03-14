variable "region" {
    type = string
    description = "The AWS region to deploy to"
}

variable "availability_zone" {
    type = string
    description = "The AWS availability zone to deploy to"
}

variable "ami" {
    type = string
    description = "The AMI to use for the EC2 instance"
}

variable "bucket_name" {
    type = string
    description = "The name of the S3 bucket to create"
}

variable "database_name" {
    type = string
    description = "The name of the RDS database to create"
}

variable "database_user" {
    type = string
    description = "The username for the RDS database"
}

variable "database_pass" {
    type = string
    description = "The password for the RDS database"
}

variable "admin_user" {
    type = string
    description = "The username for the EC2 instance"
}

variable "admin_pass" {
    type = string
    description = "The password for the EC2 instance"
}