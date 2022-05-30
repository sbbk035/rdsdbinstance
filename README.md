# Created RDS MySQL DB Instance in AWS using Terraform code.
# For providing security to the DB Instance,it is created in separate VPC and Subnet Group, 
  and also it is associated to security group for restricting traffic to particular IP addresses
  (but in the security group created here, allowed all traffic).
# For accessing this DB instance, i created EC2 Instance and installed MySQL client in it
  (since for this DB instance, publicly_accessible is set as false so it not accessable from external).

  
