#buckets
resource "aws_s3_bucket" "firstbucket" {
  bucket = "terraform-first26547203"
  acl = "private"
}

resource "aws_s3_bucket_object" "raw" {
  bucket = aws_s3_bucket.firstbucket.id
  key = "raw/test-file.txt"
  source = "teste-file.txt"
}

resource "aws_s3_bucket_object" "cleaned" {
    bucket = aws_s3_bucket.firstbucket.id
    key = "cleaned/test-file.txt"
    source = "teste-file.txt"
}

resource "aws_s3_bucket_object" "curated" {
    bucket = aws_s3_bucket.firstbucket.id
    key = "curated/test-file.txt"
    source = "teste-file.txt"
}

resource "aws_s3_bucket_object" "scripts" {
    bucket = aws_s3_bucket.firstbucket.id
    key = "scripts/test-file.txt"
    source = "teste-file.txt"
}

resource "aws_glue_crawler" "raw-tables"{
  database_name="s3://olist-project-dw/raw/"
  name = "olist-raw-tables"
  role = "${var.olist_role}"
  recrawl_policy {
    recrawl_behavior = "CRAWL_NEW_FOLDERS_ONLY"
  }
  catalog_target {
    database_name = "olist-project-cleaned"
    tables = var.list_of_tables
  }
}

resource "aws_glue_crawler" "cleaned-tables"{
  database_name="s3://olist-project-dw/cleaned/"
  name = "olist-cleaned-tables"
  role = "${var.olist_role}"
  recrawl_policy {
    recrawl_behavior = "CRAWL_NEW_FOLDERS_ONLY"
  }
  catalog_target {
    database_name = "olist-project-cleaned"
    tables = var.list_of_tables
  }
}

resource "aws_glue_crawler" "curated-tables"{
  database_name="s3://olist-project-dw/curated/"
  name = "olist-curated-tables"
  role = "${var.olist_role}"
  recrawl_policy {
    recrawl_behavior = "CRAWL_NEW_FOLDERS_ONLY"
  }
  catalog_target {
    database_name = "olist-project-curated"
    tables = var.list_of_tables
  }
}


#jobs
resource "aws_glue_job" "raw-to-cleaned"{
  name = "raw-to-cleaned"
  description = "This job gets the new data from the raw zone, passes through some pré-processing and writes the data on the cleaned zone. "
  role_arn = "${var.olist_role}"
  max_retries = 1
  glue_version = "3.0"  
  worker_type = "G.1X" 
  number_of_workers = 2

  command {
    script_location = "s3://olist-project-dw/scripts/raw-cleaned.py" #var
  }
}

resource "aws_glue_job" "cleaned-to-curated"{
  name = "cleaned-to-curated"
  description = "This job gets the new data from the cleaned zone, passes through some other processess and writes the data on the curated zone. "
  role_arn = "${var.olist_role}" 
  max_retries = 1
  glue_version = "3.0"  
  worker_type = "G.1X" 
  number_of_workers = 2

  command {
    script_location = "s3://olist-project-dw/scripts/cleaned-curated.py" #var
  }
}

#redshift cluster
resource "aws_redshift_cluster" "redshift-cluster" {
  depends_on = [
    aws_vpc.redshift-vpc,
    aws_redshift_subnet_group.redshift-subnet-group,
    aws_iam_role.redshift-role
  ]

  cluster_identifier = var.redshift_cluster_identifier
  database_name = var.redshift_database_name
  master_username = var.redshift_admin_username
  master_password = var.redshift_admin_password
  node_type = var.redshift_node_type
  cluster_type = var.redshift_cluster_type
  number_of_nodes = var.redshift_number_of_nodes

  iam_roles = [aws_iam_role.redshift-role.arn]
  
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift-subnet-group.id

  skip_final_snapshot = true
}
