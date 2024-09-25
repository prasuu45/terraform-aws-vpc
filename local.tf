locals {
    #who use my module - using which project, environment to find out using locals 
    # i want to  vpc= expence-(dev orprod)
  resource_name = "${var.project_name}-${var.environment}"
  # i want frist to elements list in terraform
  
  az_names = slice(data.aws_availability_zones.available.names, 0, 2)
}