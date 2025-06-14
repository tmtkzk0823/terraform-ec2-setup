# keypair
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/my-project-dev-keypair.pub")

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    project = var.project
    Env     = var.environment
  }
}

# EC2 instance

resource "aws_instance" "application_server" {
  ami           = data.aws_ami.app.id
  instance_type = "t4g.nano"
  subnet_id     = aws_subnet.public_subnet_1a.id
  vpc_security_group_ids = [
    aws_security_group.app_sg.id,
    aws_security_group.opmng_sg.id
  ]

  key_name = aws_key_pair.keypair.key_name





  tags = {
    Name    = "${var.project}-${var.environment}-app-ec2"
    project = var.project
    Env     = var.environment
    Type    = "app"
  }
}
