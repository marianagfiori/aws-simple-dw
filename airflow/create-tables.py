from datetime import timedelta

from airflow import DAG
from airflow.models import Variable
from airflow.models.baseoperator import chain
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.utils.dates import days_ago


s3_bucket = "olist-project-dw"
s3_key = "curated/"
schema = "olist-simple-dw"
tables = ["dim_customer", "dim_geolocation", "fact_selling", "dim_order", "dim_payments", "dim_review", "dim_product", "dim_seller"]

default_args = {
    "owner": "Mariana",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay":timedelta(minutes=1),
    "postgres_conn_id": "aws-connection-redshift-s3-simple-dw-project1"
}

with DAG(
    dag_id='create tables',
    description="Cria tabelas no bucket",
    default_args=default_args,
    schedule_interval=None,
) as dag:
    create_tables = PostgresOperator(
        task_id="create_tables", sql="airflow/create-tables.py"
    )

    for table in tables:
        drop_tables = PostgresOperator(
            task_id=f"drop_table_{table}", sql=f"DROP TABLE IF EXISTS {schema}.{table};"
        )

        chain(drop_tables, create_tables)