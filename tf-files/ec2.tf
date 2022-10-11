resource "aws_key_pair" "jumphost-key" {
  key_name   = "jumphost-key"
  public_key = var.public-key
}

resource "aws_security_group" "jumphost-sg" {
  name        = "${var.environment}-jumphost-sg"
  description = "Security group for Jumphost"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "jumphost" {
  ami                         = var.ami
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.jumphost-key.key_name
  monitoring                  = true
  security_groups             = [aws_security_group.jumphost-sg.id]

  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp2"
  }
  tags = {
    Name        = "${var.environment}-jumphost"
    Environment = var.environment
  }

  user_data = <<-EOF
  #!/bin/bash -xe
  sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
  apt-get update -y
  apt-get install postgresql -y
  wget https://raw.githubusercontent.com/utkarsh17naik/operations-task-utkarsh/master/db/rates.sql
  sleep 25
  export PGPASSWORD='${aws_db_instance.rds.password}'
  psql -U ${aws_db_instance.rds.username} -h ${aws_db_instance.rds.address} -d ${aws_db_instance.rds.db_name} -f rates.sql 
  EOF

}
