
# API Gateway REST
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "ClienteAPI"
  description = "API Gateway para acionar a função Lambda Cliente"
}

# Recurso CPF
resource "aws_api_gateway_resource" "cpf_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "cpf"
}

# Método GET para o recurso CPF
resource "aws_api_gateway_method" "get_cpf_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.cpf_resource.id
  http_method   = "GET"
  authorization = "NONE"
      
  request_parameters = {
    "method.request.querystring.cpf" = true  # CPF como parâmetro de consulta
  }
}

# Integrar o método GET com a função Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.cpf_resource.id
  http_method             = aws_api_gateway_method.get_cpf_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.cliente_lambda.invoke_arn
}

# Permitir que a API Gateway invoque a função Lambda
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cliente_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

# Deployment da API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "prod"
}

# Saída da URL da API
output "api_gateway_invoke_url" {
  value       = "${aws_api_gateway_deployment.api_deployment.invoke_url}/cpf?cpf={cpf}"
  description = "URL de invocação da API Gateway para a função Lambda"
}
