provider "aws" {
  region = var.region
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "backend" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "Backend-Instance"
  }
}

resource "aws_instance" "frontend" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y docker.io nginx
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "Frontend-Instance"
  }
}

output "backend_public_ip" {
  value = aws_instance.backend.public_ip
}

output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}
