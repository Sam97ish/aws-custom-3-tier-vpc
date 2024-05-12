output "arn" {
  description = "value of the arn for the vpc"
  value       = aws_vpc.main-vpc.arn
}

output "id" {
  description = "value of the id for the vpc"
  value       = aws_vpc.main-vpc.id
}

output "cidr_block" {
  description = "value of the cidr block for the vpc"
  value       = aws_vpc.main-vpc.cidr_block
}

output "vpc_all_tags" {
  value = aws_vpc.main-vpc.tags_all
}
