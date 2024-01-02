# Creating resource variable
variable "transcribe_function_name" {}
variable "transcribe_file_name" {}
variable "summy_function_name" {}
variable "summy_file_name" {}
variable "handler_name" {}
variable "runtime" {}
variable "timeout" {}
variable "mp3_bucket_name" {}
variable "json_bucket_name" {}
variable "txt_bucket_name" {}
variable "nltk_layer_name" {}
variable "nltk_layer_file_name" {}
variable "flask_layer_name" {}
variable "flask_layer_file_name" {}
variable "key_name" {}
variable "ami_image" {}

# EC2 key pair creation
# resource "aws_key_pair" "summarizer_key" {
#   key_name   = var.key_name
#   public_key = tls_private_key.rsa.public_key_openssh
# }

# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "local_file" "summarizer_key" {
#     content  = tls_private_key.rsa.private_key_pem
#     filename = var.key_name
# }

# Create policy for role

resource "aws_iam_role" "role" {
  name = "termproject_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "term-role"
  }
}


# Give permissions to S3FullAccess and TranscribeFullAccess
resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/ComprehendFullAccess"
  ])
  role       = aws_iam_role.role.name
  policy_arn = each.value
}


# BackEnd Structure

# Create lambda function to start a transcribe job and store the output json in a s3 bucket
resource "aws_lambda_function" "transcribe_lambda" {
    function_name    = "${var.transcribe_function_name}"
    role             = aws_iam_role.role.arn
    handler          = "${var.handler_name}.lambda_handler"
    runtime          = "${var.runtime}"
    timeout          = "${var.timeout}"
    filename         = "${var.transcribe_file_name}.zip"
    source_code_hash = "${filebase64("${var.transcribe_file_name}.zip")}"
}

# To create S3 notification for transcribe lambda trigger
resource "aws_s3_bucket_notification" "transcribe_lambda_trigger" {
    bucket = aws_s3_bucket.mp3_bucket.id
    lambda_function {
        lambda_function_arn = aws_lambda_function.transcribe_lambda.arn
        events              = ["s3:ObjectCreated:*"]
        filter_suffix       = ".mp3"
    }
}

# To give transcribe lambda permission
resource "aws_lambda_permission" "transcribe_lambda_permission" {
    statement_id = "AllowExecutionFromS3Bucket"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.transcribe_lambda.function_name
    principal = "s3.amazonaws.com"
    source_arn = "arn:aws:s3:::${aws_s3_bucket.mp3_bucket.id}"
}

# Create lambda function to take a json file, extract the trasncript, get the summary of the text 
# using summy library and store result in a s3 bucket
resource "aws_lambda_function" "summy_lambda" {
    function_name    = "${var.summy_function_name}"
    role             = aws_iam_role.role.arn
    handler          = "${var.handler_name}.lambda_handler"
    runtime          = "${var.runtime}"
    timeout          = "${var.timeout}"
    filename         = "${var.summy_file_name}.zip"
    source_code_hash = "${filebase64("${var.summy_file_name}.zip")}"
    layers = [aws_lambda_layer_version.flask_layer.arn, aws_lambda_layer_version.nltk_layer.arn]
    environment {
      variables = {
        NLTK_DATA = "/opt/nltk_data"
      }
    }
}

resource "aws_lambda_layer_version" "nltk_layer" {
  layer_name = "${var.nltk_layer_name}"
  filename   = "${var.nltk_layer_file_name}.zip"
  source_code_hash = "${filebase64("${var.nltk_layer_file_name}.zip")}"
  compatible_runtimes = [var.runtime]
}

resource "aws_lambda_layer_version" "flask_layer" {
  layer_name = "${var.flask_layer_name}"
  filename   = "${var.flask_layer_file_name}.zip"
  source_code_hash = "${filebase64("${var.flask_layer_file_name}.zip")}"
  compatible_runtimes = [var.runtime]
}

# To create S3 notification for summy lambda trigger
resource "aws_s3_bucket_notification" "summy_lambda_trigger" {
    bucket = aws_s3_bucket.json_bucket.id
    lambda_function {
        lambda_function_arn = aws_lambda_function.summy_lambda.arn
        events              = ["s3:ObjectCreated:*"]
        filter_suffix       = ".json"
    }
}

# To give lambda permission
resource "aws_lambda_permission" "summy_lambda_permission" {
    statement_id  = "AllowS3Invoke"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.summy_lambda.function_name
    principal = "s3.amazonaws.com"
    source_arn = "arn:aws:s3:::${aws_s3_bucket.json_bucket.id}"
}

# To create S3 bucket to store the input audio as a mp3 file
resource "aws_s3_bucket" "mp3_bucket" {
  bucket = "${var.mp3_bucket_name}"
}

resource "aws_s3_bucket_public_access_block" "mp3_bucket_block" {
bucket = aws_s3_bucket.mp3_bucket.id
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true
}

# To create S3 bucket to store the output of transcribe job as a json file
resource "aws_s3_bucket" "json_bucket" {
  bucket = "${var.json_bucket_name}"
}

# To create S3 bucket to store the output of summy summarizer as a txt file
resource "aws_s3_bucket" "txt_bucket" {
  bucket = "${var.txt_bucket_name}"
}

resource "aws_s3_bucket_public_access_block" "txt_bucket_block" {
bucket = aws_s3_bucket.txt_bucket.id
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true
}

# FrontEnd Structure

# Security Groups and Rules

resource "aws_security_group_rule" "rule1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.forwarder.id
}

resource "aws_security_group_rule" "rule2" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.forwarder.id
}

resource "aws_security_group_rule" "rule3" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.forwarder.id
}

resource "aws_security_group_rule" "rule4" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.forwarder.id
}

resource "aws_security_group" "forwarder" {
}

# EC2 creation
resource "aws_instance" "instance" {
  ami = var.ami_image
  instance_type = "t2.nano"
  key_name = var.key_name
  tags = {
      Name = "Summarizer_FrontEnd"
  }
}

# Attaching Security Group to EC2
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.forwarder.id
  network_interface_id = aws_instance.instance.primary_network_interface_id
}

# # ###########
# # # output of lambda arn
# # ###########
# output "arn" {
# value = "${aws_lambda_function.summy_lambda.arn}"
# }