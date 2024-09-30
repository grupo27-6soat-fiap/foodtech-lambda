
import boto3
import os
import json

dynamodb = boto3.resource('dynamodb')
cognito_client = boto3.client('cognito-idp')
table_name = os.environ.get('TABLE_NAME', 'cliente')
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Verificando se o parâmetro 'cpf' foi passado
    # cpf = event.get('cpf')
    cpf = event.get('queryStringParameters', {}).get('cpf')
    
    client_id = "{{CLIENT_ID_COGNITO}}"
    username = "{{USERNAME_COGNITO}}"
    password = "{{PASSWORD_COGNITO}}"

    # client_id = '6qiiu83umrl4e6ga04vtvjp2ut'
    

    if not cpf :
        return {
            'statusCode': 400,
            'body': 'Parâmetros CPF não fornecido.'
        }

    # Fazendo a busca no DynamoDB
    try:
        response = table.get_item(Key={'cpf': cpf})
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao acessar o DynamoDB: {str(e)}'
        }

    # Verificando se o usuário foi encontrado
    if 'Item' not in response:
        return {
            'statusCode': 401,
            'body': 'Unauthorized'
        }

    # Usuário encontrado, autenticar no Cognito
    try:
        auth_response = cognito_client.initiate_auth(
            ClientId=client_id,
            AuthFlow='USER_PASSWORD_AUTH',
            AuthParameters={
                'USERNAME': username,
                'PASSWORD': password
            }
        )
    except cognito_client.exceptions.NotAuthorizedException:
        return {
            'statusCode': 401,
            'body': 'Unauthorized'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Erro ao autenticar no Cognito: {str(e)}'
        }

    # Retornar o access token
    access_token = auth_response['AuthenticationResult']['AccessToken']
    item = response['Item']
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'mensagem': 'Sucesso',
            'dados': item,
            'access_token': access_token,
            'auth_response': auth_response
        })
    }
