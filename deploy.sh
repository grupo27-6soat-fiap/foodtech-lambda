#!/bin/bash


# Substitui placeholders no código Python com os valores dos secrets
echo "Substituindo as variáveis de ambiente nos arquivos Python..."
sed -i "s/{{CLIENT_ID_COGNITO}}/${CLIENT_ID_COGNITO}/g" lambda_function/lambda_function.py
sed -i "s/{{USERNAME_COGNITO}}/${USERNAME_COGNITO}/g" lambda_function/lambda_function.py
sed -i "s/{{PASSWORD_COGNITO}}/${PASSWORD}/g" lambda_function/lambda_function.py


# Zipa o código da Lambda
echo "Compactando o código da Lambda..."
zip -j lambda_function.zip lambda_function/lambda_function.py
# cat lambda_function/lambda_function.py


# Executa os comandos do Terraform
echo "Iniciando o Terraform..."
terraform init

echo "Aplicando o Terraform..."
terraform apply -auto-approve \
  -var="client_id_cognito=$CLIENT_ID_COGNITO" \
  -var="username_cognito=$USERNAME_COGNITO" \
  -var="password_cognito=$PASSWORD"
