resource "aws_api_gateway_rest_api" "flask-apigw" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "flask-apigw"
      version = "1.0"
    }
    paths = {
      "/" = {
        get = {
          x-amazon-apigateway-integration = {
            payloadFormatVersion = "1.0"
            httpMethod           = "POST"
            type                 = "AWS_PROXY"
            uri                  = "${aws_lambda_function.flask-lambda-function.invoke_arn}"
          }
        }
      }
    }
  })

  name = "flask-apigw"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "flask-apigw-deploy" {
  rest_api_id = aws_api_gateway_rest_api.flask-apigw.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.flask-apigw.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "flask-apigw-stage" {
  deployment_id = aws_api_gateway_deployment.flask-apigw-deploy.id
  rest_api_id   = aws_api_gateway_rest_api.flask-apigw.id
  stage_name    = "flask-apigw-stage"
}
