# parameter group
resource "aws_db_parameter_group" "mysql_standalone_parameter_group" {
  name   = "${var.project}-${var.environment}-mysql-parameter-group"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# option group
resource "aws_db_option_group" "mysql_standalone_option_group" {
  name                 = "${var.project}-${var.environment}-mysql-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# RDS subnet group
resource "aws_db_subnet_group" "mysql_standalone_subnet_group" {
  name = "${var.project}-${var.environment}-mysql_standalone-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnet-group"
    project = var.project
    Env     = var.environment
  }
}

# RDS instance
resource "random_string" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "mysql_standalone" {
  identifier     = "${var.project}-${var.environment}-mysql-standalone"
  engine         = "mysql"
  engine_version = "8.0"

  username = "admin"
  password = random_string.db_password.result

  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  storage_encrypted      = false
  multi_az               = false
  availability_zone      = "ap-northeast-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306

  db_name              = "myproject"
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parameter_group.name
  option_group_name    = aws_db_option_group.mysql_standalone_option_group.name

  auto_minor_version_upgrade = false
  deletion_protection        = true
  skip_final_snapshot        = false

  apply_immediately = true

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone"
    project = var.project
    Env     = var.environment
  }
}


