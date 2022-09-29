resource "aws_lambda_function" "python_picture_lambda" {
  filename      = "serverless-exif-remover.zip"
  function_name = local.lambda_name
  role          = aws_iam_role.iam_role_for_python_picture_lambda.arn
  handler       = "main.handler"

  timeout = 10
  memory_size = 256

  source_code_hash = data.archive_file.lambda_serverless-exif-remover.output_base64sha256

  runtime = "python3.9"

  environment {
    variables = {
      bucketB = var.BUCKET_B
    }
  }
}


# Gives an external source (like a CloudWatch Event Rule, SNS, or S3) 
# permission to access the Lambda function.
resource "aws_lambda_permission" "allow_bucket_trigger_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.python_picture_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket-a.arn
}

resource "aws_s3_bucket_notification" "python_picture_lambda_trigger" {
  bucket = var.BUCKET_A

  lambda_function {
      lambda_function_arn = "${aws_lambda_function.python_picture_lambda.arn}"
      events              = ["s3:ObjectCreated:*"]
      filter_suffix       = ".jpg"
  }
}
