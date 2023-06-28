<<<<<<< HEAD
##########################
# Application Definition # 
##########################
app_name        = "dw-olist-simple" 
app_environment = "Test" # Dev, Test, Staging, Prod, etc

#########################
# Network Configuration #
#########################
redshift_vpc_cidr      = "10.20.0.0/16"
redshift_subnet_1_cidr = "10.20.1.0/24"
redshift_subnet_2_cidr = "10.20.2.0/24"

################################
## Redshift Cluster Variables ##
################################
redshift_cluster_identifier = "olist-dw-simple"
redshift_database_name      = "olist_dw"
redshift_admin_username     = "admin"
redshift_admin_password     = "admin0l1sT"
redshift_node_type          = "dc2.large"
redshift_cluster_type       = "single-node"
=======
##########################
# Application Definition # 
##########################
app_name        = "dw-olist-simple" 
app_environment = "Test" # Dev, Test, Staging, Prod, etc

#########################
# Network Configuration #
#########################
redshift_vpc_cidr      = "10.20.0.0/16"
redshift_subnet_1_cidr = "10.20.1.0/24"
redshift_subnet_2_cidr = "10.20.2.0/24"

################################
## Redshift Cluster Variables ##
################################
redshift_cluster_identifier = "olist-dw-simple"
redshift_database_name      = "olist_dw"
redshift_admin_username     = "admin"
redshift_admin_password     = "admin0l1sT"
redshift_node_type          = "dc2.large"
redshift_cluster_type       = "single-node"
>>>>>>> 62d4462235b06f83667f43a82a6c8ba5d4dbce61
redshift_number_of_nodes    = 1