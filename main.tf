resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames 

  tags = merge(
    var.common_tags,
    var.vpc-tags,
    {
        Name = local.resource_name
    }
  )
}
# internet_gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
        Name = local.resource_name
    }
  )
}

#subnets

 resource "aws_subnet" "public" {
  count = length(var.public-subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public-subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
        
        Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private-subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private-subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
        
        Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}

resource "aws_subnet" "database" {
  count = length(var.database-subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database-subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
        
        Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )
}
# elastic ip

resource "aws_eip" "nat" {
  domain   = "vpc"
}
# natgate way

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id 

  tags = merge(
    var.common_tags,
    var.nat_gateway_tags,
    {
        
        Name = "local.resource_name"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
# route_tables

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id 

  tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
        
        Name = "${local.resource_name}-public"
    }
  )
}


resource "aws_route_table" "privat" {
  vpc_id = aws_vpc.main.id 

  tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
        
        Name = "${local.resource_name}-private"
    }
  )
}
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id 

  tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
        
        Name = "${local.resource_name}-database"
    }
  )
}
# routes

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/16"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.privat.id
  destination_cidr_block    = "0.0.0.0/16"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/16"
  nat_gateway_id = aws_nat_gateway.main.id
}
#route_table_assciation

resource "aws_route_table_association" "public" {
  count = length(var.public-subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private-subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.privat.id
}
resource "aws_route_table_association" "database" {
  count = length(var.database-subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}



