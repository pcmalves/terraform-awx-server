# Servidor AWX com Terraform

No processo de instalação do AWX o clone está sendo direto do Github [AWX Project](https://github.com/ansible/awx).  

Aqui estou apenas fazendo o processo de instalação automatizado. Adicionarei melhorias posteriormente.

Subi um instância **t3.medium** que vai de encontro com a documentação do **AWX Project**.

Este repositório auxilia na seguintes tarefas:

- Criação da infra em um ambiente cloud AWS
- Efetua processo de instalação automatizado do servidor

O processo todo deve dar em torno de 10 á 15 minutos para conclusão. Após a conclusão da construção da infra, ainda há parametrização do ambiente que irá hospedar o servidor **AWX**

Os arquivos de logs da instalação fica dentro da instância em **/var/log/cloud-init-output.log**. 

Para subir o ambiente, é necessário fazer o clone do repositório. Dentro do diretório **terraform-awx-server** execute os seguintes comandos:

```bash
$ rm -rf .terraform/ && terraform fmt && terraform init && terraform validate && terraform plan
```

O **plan** dará um overview dos recursos que serão criados. Depois é só executar **terraform apply** para criar os recursos.

OBS: Neste projeto estou utilizando a versão 0.11.8 do Terraform. Em breve farei uma atualização para versão 0.12. Outro detalhe, é necessário a instalaçao e configuração do aws-cli

[Linkedin](https://www.linkedin.com/in/pcmalves/)