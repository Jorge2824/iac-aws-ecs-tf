# iac-aws-ecs-tf
Este repositorio contiene código Terraform para manejar Infraestructura como código para la prueba de Interseguros en AWS

## Prerequisitos

- [Terraform](https://www.terraform.io/downloads.html) v1.0.0 or later
- AWS CLI configurado con sus propias credenciales y con el permiso "AdministratorAccess"

## Setup

1. **Clonar el repositorio**

   ```sh
   git clone https://github.com/Jorge2824/iac-aws-ecs-tf.git
   cd iac-aws-ecs-tf

2. **Inicializar Terraform**

   ```sh
   terraform init

3. **Validar Código Terraform**

   ```sh
   terraform validate

4. **Crear Terraform Plan**

   ```sh
   terraform plan

5. **Aplicar Terraform Plan**

   ```sh
   terraform apply

## Limpiar
Para eliminar la infraesctructura creada por Terraform, usa el siguiente comando:
   ```sh
   terraform destroy