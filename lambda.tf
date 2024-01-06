resource "aws_lambda_function" "flask-lambda-function" {
  function_name = "flask-lambda-function"
  #   s3_bucket     = "terraform-serverless-example-jyo"
  #   s3_key        = "v1.0.0/first-web-flask.zip"
  handler  = "app.handler"
  runtime  = "python3.9"
  timeout  = 10
  filename = "./first-web-flask.zip"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_flask_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
