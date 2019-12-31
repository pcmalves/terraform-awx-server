# Servidor AWX com Terraform

No processo de instalação do AWX estou fazendo o clone direto do Github [AWX Project](https://github.com/ansible/awx).  

Aqui estou apenas fazendo o processo de instalação automatizado. Adicionarei melhorias posteriormente.

Subi um instância **t2.medium** que vai de encontro com a documentação do **AWX Project**

Este repositório auxilia na seguintes tarefas:

- Criação da infra em um ambiente cloud AWS
- Efetua processo de instalação automatizado do servidor

Para testar localmente, é necessário fazer o clone do repositório. Dentro do diretório **terraform-awx-server** execute os seguintes comandos:

```bash
$ rm -rf .terraform/ && terraform fmt && terraform init && terraform validate && terraform plan
```

OBS: Neste projeto estou utilizando a versão 0.11.8 do Terraform. Em breve farei uma atualização para versão 0.12.