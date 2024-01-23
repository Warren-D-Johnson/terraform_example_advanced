instances = ["dbcluster-instance1", "dbcluster-instance2", "dbcluster-instance3"]

subnet_names = {
  "dbcluster-instance1" = "High Availability A",
  "dbcluster-instance2" = "High Availability B",
  "dbcluster-instance3" = "High Availability C"
}

availability_zones = {
  "dbcluster-instance1" = "us-east-2a",
  "dbcluster-instance2" = "us-east-2b",
  "dbcluster-instance3" = "us-east-2c"
}

security_group_names = [
  "MariaDB Local",
  "SSH Only",
  "MariaDB Cluster Local Ports"
]

volume_tags = {
  "dbcluster-instance1" = {
    "Name": "Data Cluster Server 1",
    "Description": "Data Cluster Server 1"
  },
  "dbcluster-instance2" = {
    "Name": "Data Cluster Server 2",
    "Description": "Data Cluster Server 2"
  },
  "dbcluster-instance3" = {
    "Name": "Data Cluster Server 3",
    "Description": "Data Cluster Server 3"
  }
}

instance_tags = {
  "dbcluster-instance1" = {
    "Name": "Data Cluster Server 1",
    "Description": "Data Cluster Server 1"
  },
  "dbcluster-instance2" = {
    "Name": "Data Cluster Server 2",
    "Description": "Data Cluster Server 2"
  },
  "dbcluster-instance3" = {
    "Name": "Data Cluster Server 3",
    "Description": "Data Cluster Server 3"
  }
}

# hostnames set during ec2 creation ONLY
hostnames = {
  "dbcluster-instance1" = "db1-nv.example.net"
  "dbcluster-instance2" = "db2-nv.example.net"
  "dbcluster-instance3" = "db3-nv.example.net"
}

root_block_device = {
  "volume_type" = "gp3",
  "volume_size" = 20
}

ebs_block_device = {
  "volume_type" = "gp3",
  "volume_size" = 20
}

ec2_ami                 = "ami-12345678901234567"
ec2_instance_type       = "t3a.medium"
key_name                = "EXAMPLE-TERRAFORM-OHIO"
iam_role                = "DATA_DB_CLUSTER"
