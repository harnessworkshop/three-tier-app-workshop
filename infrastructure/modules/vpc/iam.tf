# VPC Endpoint policies for EKS private cluster communication
resource "aws_iam_role" "vpc_endpoint" {
  name = "${var.cluster_name}-vpc-endpoint-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "vpc_endpoint" {
  name = "${var.cluster_name}-vpc-endpoint-policy"
  role = aws_iam_role.vpc_endpoint.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "elasticloadbalancing:*"
        ]
        Resource = "*"
      }
    ]
  })
} 