module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  create_api_domain_name = false
  create_default_stage   = false

  name          = "yey-apigw"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  integrations = {
    "GET /ramon" = {
      lambda_arn             = "arn:aws:lambda:us-east-1:575360115351:function:yey-dev-lambda-ramon"
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }

  tags = {
    Name = "http-apigateway"
  }
}

resource "aws_apigatewayv2_stage" "example" {
  api_id = module.api_gateway.apigatewayv2_api_id
  name   = "dev"
}

resource "aws_apigatewayv2_stage" "example" {
  api_id = module.api_gateway.apigatewayv2_api_id
  name   = "prod"
}

resource "aws_api_gateway_deployment" "MyDemoDeployment" {
  depends_on = [module.api_gateway]

  rest_api_id = module.api_gateway.apigatewayv2_api_id
  stage_name  = "dev"

  lifecycle {
    create_before_destroy = true
  }
}