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