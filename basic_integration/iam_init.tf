resource "aws_iam_role" "lightlytics-init-role" {
  name = coalesce(var.init_role_name, "${var.environment}-lightlytics-init-role")
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect = "Allow",
        Principal = {
          "Service" = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lightlytics-init-policy" {
  name   = coalesce(var.init_policy_name, "${var.environment}-lightlytics-init-policy")
  path   = "/"
  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        Action = [
          "iam:ListAccountAliases",
          "ec2:DescribeFlowLogs",
          "ec2:DescribeVpcs",
          "logs:CreateLogDelivery",
          "logs:DeleteLogDelivery",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeInstances",
          "ec2:CreateTags"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lightlytics-role-attach-init" {
  role       = aws_iam_role.lightlytics-init-role.name
  policy_arn = aws_iam_policy.lightlytics-init-policy.arn
}
