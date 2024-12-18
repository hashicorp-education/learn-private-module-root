provider "aws" {
  region = var.region
}

module "s3-webapp" {
  source  = "app.terraform.io/lee-test-organization/s3-webapp/aws"
  name    = var.name
  region  = var.region
  prefix  = var.prefix
  version = "1.0.0"
}

resource "aws_s3_bucket_acl" "frontend_acl" {
  bucket = aws_s3_bucket.frontend_bucket.id
  acl    = "public-read"

depends_on = [
  aws_s3_bucket_public_access_block.frontend_public_access_block,
]
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.frontend_bucket.id}/*"
    }
  ]
}
POLICY

depends_on = [
  aws_s3_bucket_public_access_block.frontend_public_access_block,
]
}