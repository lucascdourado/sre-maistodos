data "aws_autoscaling_groups" "node_group" {
  filter {
    name   = "tag:eks:cluster-name"
    values = [var.cluster_name]
  }
}