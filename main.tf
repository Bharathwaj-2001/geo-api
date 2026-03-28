provider "aws" {
  region = var.aws_region
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "geo_api_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Attach basic policy
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "geo_api" {
  filename         = "lambda.zip"
  function_name    = "geo-api-function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("lambda.zip")
}

# API Gateway
resource "aws_api_gateway_rest_api" "geo_api" {
  name = "geo-api"
}

resource "aws_api_gateway_resource" "geo_resource" {
  rest_api_id = aws_api_gateway_rest_api.geo_api.id
  parent_id   = aws_api_gateway_rest_api.geo_api.root_resource_id
  path_part   = "geo"
}

resource "aws_api_gateway_method" "geo_method" {
  rest_api_id   = aws_api_gateway_rest_api.geo_api.id
  resource_id   = aws_api_gateway_resource.geo_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.geo_api.id
  resource_id             = aws_api_gateway_resource.geo_resource.id
  http_method             = aws_api_gateway_method.geo_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.geo_api.invoke_arn
}

resource "aws_api_gateway_deployment" "geo_deployment" {
  rest_api_id = aws_api_gateway_rest_api.geo_api.id
  depends_on  = [aws_api_gateway_integration.lambda_integration]
}

resource "aws_api_gateway_stage" "geo_stage" {
  deployment_id = aws_api_gateway_deployment.geo_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.geo_api.id
  stage_name    = "prod"
}

# Lambda Permission
resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.geo_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.geo_api.execution_arn}/*/*"
}

