# Como realizar instalação e configuração do servidor AWX com Terraform no Ubuntu-18.04

Objetivo
---
- Criar infraestrutura do servidor AWX utilizando Terraform
- Instalação do servidor AWX com shellscripts

Pré-requisito
---
- Instalação Terraform versão 0.11.8
- Instalação e configuração do aws-cli 

Passo 1 - Instalação do Terraform no Ubuntu-18.04
---

Instale pacote unzip

```bash
$ sudo apt-get install unzip
```
Download do pacote do Terraform

```bash
$ wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
```
Extraindo arquivo do download

```bash
$ unzip terraform_0.12.18_linux_amd64.zip
```

Movendo o executável para ficar disponível global

```bash
$ sudo mv terraform /usr/local/bin/
```
Testando instalação

```bash
$ terraform --version
```
Output do comando

```html
Terraform v0.11.8

Your version of Terraform is out of date! The latest version
is 0.12.19. You can update by downloading from www.terraform.io/downloads.html
```
Passo 2 - Instalação e configuração do aws-cli no Ubuntu-18.04
---

Instalando aws-cli usando python-pip

Python 2.x
```bash
$ sudo apt-get install python-pip
```

Python 3.x
```bash
$ sudo apt-get install python3-pip
```
Instalando aws-cli usando pip 

pip 2.x

```bash
$ pip install awscli --upgrade --user
```

pip 3.x

```bash
$ pip3 install awscli --upgrade --user
```
Testando instalação.

Python 2.x
```bash
$ python -m awscli --version
```
Python 3.x
```bash
$ python3 -m awscli --version
```
Output
```html
aws-cli/1.16.222 Python/2.7.17 Linux/5.0.0-37-generic botocore/1.12.212
```
Login com a conta AWS usando AWS CLI
---

Login
```bash
$ aws configure
```
Exemplo de resposta das perguntas
```html
AWS Access Key ID [None]: AKIAXBBSFRWR3QEXAMPLE
AWS Secret Key [None]: e8hyV1Z0P9GdMXkIIXe/kFdN5oEXAMPLE
Default region name [None]: us-west-2
Default output format [None]: json
```
Passo 3 - Clonando e testando o projeto localmente
---

Clonando o projeto

```bash
$ git clone https://github.com/pcmalves/terraform-awx-server.git
```
Entrando na pasta do projeto

```bash
$ cd terraform-awx-server/ 
```
Testando criação dos recursos

```bash
$ terraform init && terraform validate && terraform plan
```
Output

```html

Plan: 8 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```
Tudo ok na criação dos recursos basta dar um **apply**

```bash
$ terraform apply -auto-approve
```
Conclusão
---
Com essa documentação rápida, instalamos **Terraform**, instalamos **AWS-CLI**

Fizemos um primeiro teste com comandos do **Terraform**


[Linkedin](https://www.linkedin.com/in/pcmalves/)