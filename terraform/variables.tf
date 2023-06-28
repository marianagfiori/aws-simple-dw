<<<<<<< HEAD
variable "olist_role" {
  type = string
  description = "This is the arn role used for this entire project."
  default = "arn:aws:iam::706721111266:role/olist-dw-project"
}

variable "app_name" {
  type = string
  description = "Variable app name"
}

variable "app_environment" {
  type = string
  description = "Variable app environment"
}

variable "redshift_vpc_cidr" {
  type = string
  description = "VPC IPv4 CIDR"
}

variable "redshift_subnet_1_cidr" {
  type = string
  description = "IPv4 CIDR for Redshift subnet 1"
}

variable "redshift_subnet_2_cidr" {
  type = string
  description = "IPv4 CIDR for Redshift subnet 2"
}

variable "redshift_cluster_identifier" {
  type = string
  description = "Redshift Cluster Identifier"
}

variable "redshift_database_name"{
  type = string
  description = "Redshift database name"
}

variable "redshift_admin_username" {
  type = string
  description = "Redshift admin username"
}


variable "redshift_admin_password" {
  type = string
  description = "Redshift admin password"
}

variable "redshift_node_type" {
  type = string
  description = "Redshift Node Type"
  default = "dc2.large"
}

variable "redshift_cluster_type" {
  type = string
  description = "Redshift Cluster Type"
  default = "single-node" 
}

variable "redshift_number_of_nodes" {
  type = number
  description = "Redshift number of nodes in the cluster"
  default = 1
}

variable "list_of_tables"{
  type = list(string)
  description = "List of tables from the olist database."
  default = ["olist_customers_dataset.csv",
    "olist_geolocation_dataset.csv",
    "olist_order_items_dataset.csv",
    "olist_order_payments_dataset.csv",
    "olist_order_reviews_dataset.csv",
    "olist_orders_dataset.csv",
    "olist_products_dataset.csv",
    "olist_sellers_dataset.csv",
    "product_category_name_translation.csv"]
=======
variable "olist_role" {
  type = string
  description = "This is the arn role used for this entire project."
  default = "arn:aws:iam::706721111266:role/olist-dw-project"
}

variable "app_name" {
  type = string
  description = "Variable app name"
}

variable "app_environment" {
  type = string
  description = "Variable app environment"
}

variable "redshift_vpc_cidr" {
  type = string
  description = "VPC IPv4 CIDR"
}

variable "redshift_subnet_1_cidr" {
  type = string
  description = "IPv4 CIDR for Redshift subnet 1"
}

variable "redshift_subnet_2_cidr" {
  type = string
  description = "IPv4 CIDR for Redshift subnet 2"
}

variable "redshift_cluster_identifier" {
  type = string
  description = "Redshift Cluster Identifier"
}

variable "redshift_database_name"{
  type = string
  description = "Redshift database name"
}

variable "redshift_admin_username" {
  type = string
  description = "Redshift admin username"
}


variable "redshift_admin_password" {
  type = string
  description = "Redshift admin password"
}

variable "redshift_node_type" {
  type = string
  description = "Redshift Node Type"
  default = "dc2.large"
}

variable "redshift_cluster_type" {
  type = string
  description = "Redshift Cluster Type"
  default = "single-node" 
}

variable "redshift_number_of_nodes" {
  type = number
  description = "Redshift number of nodes in the cluster"
  default = 1
}

variable "list_of_tables"{
  type = list(string)
  description = "List of tables from the olist database."
  default = ["olist_customers_dataset.csv",
    "olist_geolocation_dataset.csv",
    "olist_order_items_dataset.csv",
    "olist_order_payments_dataset.csv",
    "olist_order_reviews_dataset.csv",
    "olist_orders_dataset.csv",
    "olist_products_dataset.csv",
    "olist_sellers_dataset.csv",
    "product_category_name_translation.csv"]
>>>>>>> 62d4462235b06f83667f43a82a6c8ba5d4dbce61
}