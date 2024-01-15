resource "aws_key_pair" "autodeploy" {
  public_key = file("/var/jenkins_home/.ssh/id_rsa.pub")
}

resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.autodeploy.key_name
  
  # Create New Volume
resource "aws_ebs_volume" "add_disk" {
 availability_zone = aws_instance.public_instance.availability_zone
 size = 10
 tags = {
   Name = "New Disk"
  }
}

# Add Disk to Ubuntu Instance
resource "aws_volume_attachment" "ebs" {
  device_name = "/dev/sdb"
  volume_id = aws_ebs_volume.add_disk.id
  instance_id = aws_instance.public_instance.id
}

# Add Disk to Ubuntu Instance
resource "aws_volume_attachment" "ebs" {
  device_name = "/dev/sdb"
  volume_id = aws_ebs_volume.add_disk.id
  instance_id = aws_instance.public_instance.id
}

  tags = {
    Name = var.name_tag
  }
}
