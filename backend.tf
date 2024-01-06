terraform {
  cloud {
    organization = "jyo"

    workspaces {
      name = "aws-lambda-apigateway-tfe"
    }
  }
}