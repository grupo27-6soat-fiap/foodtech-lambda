
# Foodtech Lambda Function

Este repositório contém a configuração e implementação da **AWS Lambda** usada pelo sistema **Foodtech**. Esta função Lambda é desenvolvida em **Python** e gerenciada por meio de **GitHub Actions** para automação de deploy.

## Visão Geral do Projeto

Este projeto utiliza a função **AWS Lambda** para lidar com processos específicos no sistema **Foodtech**, incluindo autenticação de usuários e integração com o banco de dados **DynamoDB**.

## Estrutura do Repositório

- **lambda_function/lambda_function.py**: Contém a implementação da função Lambda em **Python**.
- **.github/workflows/deploy_lambda.yml**: Contém a definição do workflow do GitHub Actions para automatizar o deploy da Lambda.

## Como Funciona

### AWS Lambda

A função **Lambda** foi desenvolvida para ser leve e eficiente, possibilitando a integração com outros serviços da AWS, como **DynamoDB** e **Cognito**. O script Python realiza as seguintes operações:

- **Autenticação**: Valida tokens e gerencia o acesso de usuários.
- **Banco de Dados**: Integra com o **DynamoDB** para armazenar e recuperar informações dos clientes.

### GitHub Actions Workflow

O workflow do GitHub Actions está configurado para automatizar o deploy da Lambda cada vez que uma mudança é realizada na branch `main`.

- **Deploy da Lambda**: O workflow `deploy_lambda.yml` faz o build do pacote, zipa o código e realiza o deploy na AWS.
- **Credenciais**: Utiliza **GitHub Secrets** para armazenar as credenciais necessárias para acessar a AWS.

## Como Configurar

### 1. Clonar o Repositório

```sh
git clone https://github.com/grupo27/foodtech-lambda.git
cd foodtech-lambda
```

### 2. Implementar e Testar a Função

- Navegue até a pasta da função:

```sh
cd lambda_function
```

- Edite o arquivo `lambda_function.py` para implementar novas funcionalidades ou corrigir bugs.

- Teste localmente antes de realizar o deploy.

### 3. Automatizar o Deploy

O deploy é automatizado através do GitHub Actions sempre que um push é feito na branch `main`. Certifique-se de configurar as variáveis de ambiente e as **secrets** no repositório do GitHub:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

## Fluxo de CI/CD

- **Build e Deploy Automático**: Quando uma alteração é feita na branch `main`, o workflow do GitHub Actions é acionado para:
  - Fazer o checkout do código.
  - Zipe o código da função Lambda.
  - Realizar o deploy com as credenciais da AWS configuradas.

## Tecnologias Utilizadas

- **AWS Lambda**: Para execução de código sem servidor.
- **Python**: Linguagem de programação usada para a Lambda.
- **GitHub Actions**: Automatização de deploy.

## Como Contribuir

1. Faça um fork do projeto.
2. Crie uma nova branch: `git checkout -b feature/nova-feature`.
3. Faça suas alterações e commit: `git commit -m 'Adicionando nova feature'`.
4. Faça push para a branch: `git push origin feature/nova-feature`.
5. Abra um Pull Request.

## Contato

Para dúvidas, entre em contato com a equipe via [email](mailto:support@foodtech.com).

---

> **Nota**: Certifique-se de que as credenciais da AWS estejam configuradas corretamente antes de aplicar qualquer configuração.

