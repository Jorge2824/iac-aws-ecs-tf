output "fiber_go_repository_url" {
    value = aws_ecr_repository.fiber-go-api-proc.repository_url
}

output "express_node_repository_url" {
    value = aws_ecr_repository.express-node-api-proc.repository_url
}