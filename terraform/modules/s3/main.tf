resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = "${lower(var.app_name)}-frontend-company-name"
  force_destroy = true
}


resource "aws_s3_object" "frontend_files" {
  for_each = fileset(var.source_dir, "**")
  bucket   = aws_s3_bucket.frontend_bucket.id
  key      = each.value
  source   = "${var.source_dir}/${each.value}"

  content_type = lookup(
    {
      html = "text/html"
      js   = "application/javascript"
      css  = "text/css"
      png  = "image/png"
      jpg  = "image/jpeg"
      svg  = "image/svg+xml"
      ico  = "image/x-icon"
    },
    split(".", each.value)[length(split(".", each.value)) - 1],
    "binary/octet-stream"
  )
}
