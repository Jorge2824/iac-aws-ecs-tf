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

4. **Crear Terraform Plan ECR**

   ```sh
  terraform plan -target='module.fiber-and-node-ecr-repositories' -out='ecr.plan'

5. **Aplicar Terraform Plan ECR**

   ```sh
   terraform apply "ecr.plan"

6. **Publicar imagenes docker ECR**
- Clonar el repositorio de https://github.com/Jorge2824/api-factorizacion-qr-go-v1 y https://github.com/Jorge2824/api-factorizacion-qr-node-v1.
- Desplegar los Dockerfiles en las urls de las imágenes del ECR creadas recientemente.

7. **Crear Terraform Plan ECS**

   ```sh
   terraform plan -target='module.ecsCluster' -out='ecs.plan'

8. **Aplicar Terraform Plan ECS**

   ```sh
   terraform apply "ecs.plan"

## Limpiar
Para eliminar la infraesctructura creada por Terraform, usa el siguiente comando:
   ```sh
   terraform destroy