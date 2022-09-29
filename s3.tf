resource "aws_s3_bucket" "bucket-a" {
  bucket = var.BUCKET_A
  acl    = "private"

  tags = {
    Name        = var.BUCKET_A
  }
}

resource "aws_s3_bucket" "bucket-b" {
  bucket = var.BUCKET_B
  acl    = "private"

  tags = {
    Name        = var.BUCKET_B
  }
}
