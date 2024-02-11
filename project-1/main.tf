resource "aws_s3_bucket" "mg-bucket-103" {
  bucket = var.proj1-s3-bucket
}

resource "aws_s3_bucket_ownership_controls" "ownership-control" {
  bucket = aws_s3_bucket.mg-bucket-103.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public-access-block" {
  bucket = aws_s3_bucket.mg-bucket-103.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership-control,
    aws_s3_bucket_public_access_block.public-access-block,
  ]

  bucket = aws_s3_bucket.mg-bucket-103.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mg-bucket-103.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  acl          = "public-read"

}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.mg-bucket-103.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
  acl          = "public-read"

}

resource "aws_s3_bucket_website_configuration" "ws-config" {
  bucket = aws_s3_bucket.mg-bucket-103.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.acl]
}




