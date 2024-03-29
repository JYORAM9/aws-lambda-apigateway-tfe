resource "aws_lambda_function" "flask-lambda-function" {
  function_name = "flask-lambda-function"
  s3_bucket     = "terraform-serverless-example-jyo"
  s3_key        = "v1.0.0/first-web-flask.zip"
  handler       = "app.handler"
  runtime       = "python3.9"
  #   filename = "./first-web-flask.zip"

  role = aws_iam_role.lambda_execution_role.arn
  vpc_config {
    subnet_ids         = [aws_subnet.example_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

resource "aws_iam_role" "lambda_execution_role" {
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

# Attach an IAM policy to the role
resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "lambda_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"

  roles = [aws_iam_role.lambda_execution_role.name]
}