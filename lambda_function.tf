
provider "aws" {
  region = "us-east-1"  # Altere conforme necessário
}


variable "client_id_cognito" {
  type = string
}

variable "username_cognito" {
  type = string
}

variable "password_cognito" {
  type = string
}


# Função Lambda
resource "aws_lambda_function" "cliente_lambda" {
  filename         = "lambda_function.zip"  # Compacte sua função como lambda_function.zip
  function_name    = "clienteLambdaFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"

   

  environment {
    variables = {
      TABLE_NAME = "cliente"
      CLIENT_ID_COGNITO = var.client_id_cognito
      USERNAME_COGNITO  = var.username_cognito
      PASSWORD_COGNITO  = var.password_cognito
      # Caso precise adicionar mais variáveis de ambiente, pode adicionar aqui
    }
  } 

  # Para utilizar bibliotecas adicionais no Lambda, como boto3, inclua-as no zip do código
  source_code_hash = filebase64sha256("lambda_function.zip")

  tags = {
    Name = "clienteLambdaFunction"
  }
}
 
# Role do IAM para a função Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role_cliente"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}
 
# Política do IAM para permitir que a função Lambda acesse DynamoDB e Cognito
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy_cliente"
  description = "Política para a função Lambda acessar DynamoDB e Cognito"
  policy      = data.aws_iam_policy_document.lambda_policy_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
} 

# Política de confiança para o Lambda assumir o papel
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Documento de política para acesso ao DynamoDB e Cognito
data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "cognito-idp:InitiateAuth"
    ]
    resources = [
      "arn:aws:dynamodb:us-east-1:637423297410:table/cliente",   # Substitua pelo seu Account ID
      "arn:aws:cognito-idp:us-east-1:637423297410:userpool/*"    # Substitua pelo seu Account ID
    ]
  }
}
