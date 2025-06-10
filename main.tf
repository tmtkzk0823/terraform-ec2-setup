provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}


resource "aws_instance" "hello-world" {
  ami           = "ami-06419057b0294628f"
  instance_type = "t3.nano"

  tags = {
    Name = "HelloWorld"
  }

  user_data = <<EOF
              #!/bin/bash
              amazon-linux-extras install -y nginx1.28
              systemctl start nginx
              EOF
}