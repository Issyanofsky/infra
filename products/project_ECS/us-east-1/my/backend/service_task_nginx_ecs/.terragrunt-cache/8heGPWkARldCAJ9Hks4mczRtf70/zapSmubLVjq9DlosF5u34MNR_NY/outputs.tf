# outputs.tf

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "iam_instance_profile_name" {
  description = "The name of the IAM instance profile"
  value       = aws_iam_instance_profile.this.name
}

output "iam_instance_profile_arn" {
  description = "The ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.this.arn
}

output "attached_policies" {
  description = "The list of IAM policy ARNs attached to the IAM role"
  value       = [for attachment in aws_iam_role_policy_attachment.policies : attachment.policy_arn]
}