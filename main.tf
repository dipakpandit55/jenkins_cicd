# Setting up VPC
//network.tf
resource "aws_vpc" "blueteam" {
  cidr_block = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support = true
  }
# Setting up the subnets
//subnets.tf
resource "aws_subnet" "subnet-uno" {
  cidr_block = "${cidrsubnet(aws_vpc.blueteam.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.blueteam.id}"
  availability_zone = "us-east-1a"
}resource "aws_key_pair" "autodeploy" {
  public_key = file("/var/jenkins_home/.ssh/id_rsa.pub")
}

resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.autodeploy.key_name
  
  // Other instance configurations...

  // Attach the primary EBS volume (default size)
  root_block_device {
    volume_size = 8  # Adjust the size based on your needs
  }

  // Attach an additional EBS volume (2 GB)
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 2
    volume_type = "gp2"  # Adjust volume type as needed
  }

  tags = {
    Name = var.name_tag,
  }
