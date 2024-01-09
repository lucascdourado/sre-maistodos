# data "aws_launch_template" "node_group" {
#   tags = {
#     "eks:cluster-name" = var.cluster_name
#   }
# }

data "aws_autoscaling_groups" "node_group" {
  filter {
    name   = "tag:eks:cluster-name"
    values = [var.cluster_name]
  }
}