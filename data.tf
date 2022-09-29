# Create the ZIP file for lambda
data "archive_file" "lambda_serverless-exif-remover" {
  type        = "zip"
  source_dir  = "${path.module}/../serverless-exif-remover"
  output_path = "${path.module}/serverless-exif-remover.zip"
}

# IAM role policy template
data "template_file" "iam_lambda_access_role_policy" {
    template = file("${path.module}/files/iam_lambda_access_policy.json")

    vars = {
        BUCKET_A = var.BUCKET_A
        BUCKET_B = var.BUCKET_B
    }
}

# IAM User A policy template
data "template_file" "iam_user_a_access_role_policy" {
    template = file("${path.module}/files/iam_user_a_policy.json")

    vars = {
        BUCKET_A = var.BUCKET_A
    }
}

# IAM User B policy template
data "template_file" "iam_user_b_access_role_policy" {
    template = file("${path.module}/files/iam_user_b_policy.json")

    vars = {
        BUCKET_B = var.BUCKET_B
    }
}
