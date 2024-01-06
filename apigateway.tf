resource "aws_api_gateway_rest_api" "flask-apigw" {
  body = jsonencode({
    "openapi" : "3.0.1",
    "info" : {
      "title" : "flask API",
      "description" : "A Flask API.",
      "version" : "1.0"
    },
    "paths" : {
      "/" : {
        "get" : {
          "operationId" : "get_handler",
          "x-amazon-apigateway-integration" : {
            "payloadFormatVersion" : "1.0",
            "httpMethod" : "GET",
            "type" : "AWS_PROXY",
            "uri" : "${aws_lambda_function.flask-lambda-function.invoke_arn}",
          },
        }
      },
      #   "/post" : {
      #     "post" : {
      #       "operationId" : "Lambda Post Greet",
      #       "requestBody" : {
      #         "content" : {
      #           "application/json" : {
      #             "schema" : {
      #               "type" : "Object"
      #             }
      #           }
      #         },
      #         "required" : true
      #       },
      #       "responses" : {
      #         "200" : {
      #           "description" : "200 response",
      #           "headers" : {
      #             "Access-Control-Allow-Origin" : {
      #               "schema" : {
      #                 "type" : "string"
      #               }
      #             }
      #           },
      #           "content" : {
      #             "application/json" : {
      #               "schema" : {
      #                 "type" : "Object"
      #               }
      #             }
      #           }
      #         }
      #       },
      #       "x-amazon-apigateway-integration" : {
      #         "payloadFormatVersion" : "1.0",
      #         "httpMethod" : "POST",
      #         "type" : "AWS_PROXY",
      #         "uri" : "${aws_lambda_function.flask-lambda-function.invoke_arn}",
      #       },
      #     }
      #   },
      #   "/put" : {
      #     "put" : {
      #       "operationId" : "Lambda Put",
      #       "requestBody" : {
      #         "content" : {
      #           "application/json" : {
      #             "schema" : {
      #               "type" : "Object"
      #             }
      #           }
      #         },
      #         "required" : true
      #       },
      #       "responses" : {
      #         "200" : {
      #           "description" : "200 response",
      #           "headers" : {
      #             "Access-Control-Allow-Origin" : {
      #               "schema" : {
      #                 "type" : "string"
      #               }
      #             }
      #           },
      #           "content" : {
      #             "application/json" : {
      #               "schema" : {
      #                 "type" : "Object"
      #               }
      #             }
      #           }
      #         }
      #       },
      #       "required" : true,
      #       "x-amazon-apigateway-integration" : {
      #         "payloadFormatVersion" : "1.0",
      #         "httpMethod" : "PUT",
      #         "type" : "AWS_PROXY",
      #         "uri" : "${aws_lambda_function.flask-lambda-function.invoke_arn}",
      #       },
      #     }
      #   },
      #   "/delete" : {
      #     "delete" : {
      #       "operationId" : "Delete",
      #       "responses" : {
      #         "200" : {
      #           "description" : "200 response",
      #           "headers" : {
      #             "Access-Control-Allow-Origin" : {
      #               "schema" : {
      #                 "type" : "string"
      #               }
      #             }
      #           },
      #           "content" : {
      #             "application/json" : {
      #               "schema" : {
      #                 "type" : "Object"
      #               }
      #             }
      #           }
      #         }
      #       },
      #       "x-amazon-apigateway-integration" : {
      #         "payloadFormatVersion" : "1.0",
      #         "httpMethod" : "DELETE",
      #         "type" : "AWS_PROXY",
      #         "uri" : "${aws_lambda_function.flask-lambda-function.invoke_arn}",
      #       },
      #     }
      #   },
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

# resource "aws_api_gateway_rest_api" "example" {
#   name        = "flask-api"
#   description = "Flask Web API"
#   body        = <<EOF
# openapi: 3.0.0
# info:
#   title: Falsk API
#   version: 1.0.0
# paths:
#   /:
#     get:
#       operationId: get_handler
#       responses:
#         '200':
#           description: Successful Get response
#   /post:
#     post:
#       operationId: post_handler
#       requestBody:
#         description: Post Request
#         required: true
#         content:
#           application/json:
#             schema:
#               type: object
#       responses:
#         '200':
#           description: Successful creation response
#   /put:
#     put:
#       operationId: put_handler
#       requestBody:
#         description: Put Request
#         required: true
#         content:
#           application/json:
#             schema:
#               type: object
#       responses:
#         '200':
#           description: Successful update response
#   /delete:
#     delete:
#       operationId: delete_handler
#       responses:
#         '204':
#           description: Successful deletion response
# EOF
# }

# resource "aws_api_gateway_resource" "get_resource" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   parent_id   = aws_api_gateway_rest_api.example.root_resource_id
#   path_part   = "/"
# }

# resource "aws_api_gateway_resource" "post_resource" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   parent_id   = aws_api_gateway_rest_api.example.root_resource_id
#   path_part   = "/post"
# }

# resource "aws_api_gateway_resource" "put_resource" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   parent_id   = aws_api_gateway_rest_api.example.root_resource_id
#   path_part   = "/put"
# }

# resource "aws_api_gateway_resource" "delete_resource" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   parent_id   = aws_api_gateway_rest_api.example.root_resource_id
#   path_part   = "/delete"
# }

# resource "aws_api_gateway_method" "get_method" {
#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   resource_id   = aws_api_gateway_resource.get_resource.id
#   http_method   = "GET"
#   authorization = "NONE"
# }


# resource "aws_api_gateway_method" "post_method" {
#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   resource_id   = aws_api_gateway_resource.post_resource.id
#   http_method   = "POST"
#   authorization = "NONE"
# }


# resource "aws_api_gateway_method" "put_method" {
#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   resource_id   = aws_api_gateway_resource.put_resource.id
#   http_method   = "PUT"
#   authorization = "NONE"
# }


# resource "aws_api_gateway_method" "delete_method" {
#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   resource_id   = aws_api_gateway_resource.delete_resource.id
#   http_method   = "DELETE"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "get_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.example.id
#   resource_id             = aws_api_gateway_resource.get_resource.id
#   http_method             = aws_api_gateway_method.get_method.http_method
#   integration_http_method = "GET"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.flask-lambda-function.invoke_arn
# }

# resource "aws_api_gateway_integration" "post_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.example.id
#   resource_id             = aws_api_gateway_resource.post_resource.id
#   http_method             = aws_api_gateway_method.post_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.flask-lambda-function.invoke_arn
# }

# resource "aws_api_gateway_integration" "put_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.example.id
#   resource_id             = aws_api_gateway_resource.put_resource.id
#   http_method             = aws_api_gateway_method.put_method.http_method
#   integration_http_method = "PUT"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.flask-lambda-function.invoke_arn
# }

# resource "aws_api_gateway_integration" "delete_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.example.id
#   resource_id             = aws_api_gateway_resource.delete_resource.id
#   http_method             = aws_api_gateway_method.delete_method.http_method
#   integration_http_method = "DELETE"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.flask-lambda-function.invoke_arn
# }

# resource "aws_api_gateway_method_response" "get_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   resource_id = aws_api_gateway_resource.get_resource.id
#   http_method = aws_api_gateway_method.get_method.http_method
#   status_code = "200"

#   response_models = {
#     "application/yaml" = "Empty"  # Use "Empty" to prevent default JSON response
#   }
# }

# resource "aws_api_gateway_integration_response" "get_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   resource_id = aws_api_gateway_resource.get_resource.id
#   http_method = aws_api_gateway_method.get_method.http_method
#   status_code = aws_api_gateway_method_response.get_method_response.status_code

#   content_handling = "CONVERT_TO_TEXT"

#   response_parameters = {
#     "method.response.header.Content-Type" = "'application/yaml'"
#   }

#   response_templates = {
#     "application/yaml" = <<EOT
#     # Convert JSON to YAML using yamlencode
#     $util.yaml(YAML.stringify($input.json('$')), false)
#     EOT
#   }
# }

# resource "aws_api_gateway_method_response" "post_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   resource_id = aws_api_gateway_resource.post_resource.id
#   http_method = aws_api_gateway_method.post_method.http_method
#   status_code = "200"

#   response_models = {
#     "application/yaml" = "Empty"  # Use "Empty" to prevent default JSON response
#   }
# }

# resource "aws_api_gateway_integration_response" "post_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   resource_id = aws_api_gateway_resource.post_resource.id
#   http_method = aws_api_gateway_method.post_method.http_method
#   status_code = aws_api_gateway_method_response.post_method_response.status_code

#   content_handling = "CONVERT_TO_TEXT"

#   response_parameters = {
#     "method.response.header.Content-Type" = "'application/yaml'"
#   }

#   response_templates = {
#     "application/yaml" = <<EOT
#     # Convert JSON to YAML using yamlencode
#     $util.yaml(YAML.stringify($input.json('$')), false)
#     EOT
#   }
# }

# resource "aws_api_gateway_method_response" "put_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   resource_id = aws_api_gateway_resource.put_resource.id
#   http_method = aws_api_gateway_method.put_method.http_method
#   status_code = "200"

#   response_models = {
#     "application/yaml" = "Empty"  # Use "Empty" to prevent default JSON response
#   }
# }

# resource "aws_api_gateway_integration_response" "put_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   resource_id = aws_api_gateway_resource.put_resource.id
#   http_method = aws_api_gateway_method.put_method.http_method
#   status_code = aws_api_gateway_method_response.put_method_response.status_code

#   content_handling = "CONVERT_TO_TEXT"

#   response_parameters = {
#     "method.response.header.Content-Type" = "'application/yaml'"
#   }

#   response_templates = {
#     "application/yaml" = <<EOT
#     # Convert JSON to YAML using yamlencode
#     $util.yaml(YAML.stringify($input.json('$')), false)
#     EOT
#   }
# }

# resource "aws_api_gateway_method_response" "delete_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   resource_id = aws_api_gateway_resource.delete_resource.id
#   http_method = aws_api_gateway_method.delete_method.http_method
#   status_code = "200"

#   response_models = {
#     "application/yaml" = "Empty"  # Use "Empty" to prevent default JSON response
#   }
# }

# resource "aws_api_gateway_integration_response" "delete_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   resource_id = aws_api_gateway_resource.delete_resource.id
#   http_method = aws_api_gateway_method.delete_method.http_method
#   status_code = aws_api_gateway_method_response.delete_method_response.status_code

#   content_handling = "CONVERT_TO_TEXT"

#   response_parameters = {
#     "method.response.header.Content-Type" = "'application/yaml'"
#   }

#   response_templates = {
#     "application/yaml" = <<EOT
#     # Convert JSON to YAML using yamlencode
#     $util.yaml(YAML.stringify($input.json('$')), false)
#     EOT
#   }
# }