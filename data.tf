data "aws_prefix_list" "s3_pr" {
  name = "com.amazonaws.*.s3"
}