# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "test" {
  ami                    = var.instance_ami
  #instance_type          = "t2.micro"
  instance_type          = "t2.small" #choose t2.small for this task
  subnet_id              = var.subnet_ids
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.key


  tags = {
    Name = "jenkins-EC2"
  }
}