from airflow import DAG
from airflow.providers.amazon.aws.transfers.s3_to_redshift import S3ToRedshiftOperator
from airflow.providers.amazon.aws.operators.glue_crawler import GlueCrawlerOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'Mariana',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
    'start_date':datetime(2023, 5, 10)
}

aws_connection = 'aws-connection-s3-simple-dw-project1'
s3_bucket='olist-project-dw'
s3_key='curated/'


crawler_cleaned_task = GlueCrawlerOperator(
    task_id="cataloga_tabelas_curated",
    aws_conn_id=aws_connection,
    config={
              'Name':'olist-curated-ingest',
              'Role':'olist-dw-project',
              'DatabaseName':'olist-project-curated',
              'Targets':{'S3Targets':[{'Path':'s3://olist-project-dw/curated/'}]}
      },
    region_name="us-east-1",
    wait_for_completion=True
  )


with DAG(
    default_args= default_args,
    dag_id="olist-transfer-to-redshift",
    description="Transfer the curated data to a Data Warehouse located in AWS Redshift.",
    schedule_interval=timedelta(days=1)

) as dag1:
    transfer_task=S3ToRedshiftOperator(
        task_id="transfer data from a bucket to redshift",
        s3_bucket = s3_bucket,
        s3_key=s3_key,
        redshift_conn_id="aws-connection-redshift-s3-simple-dw-project1",
        copy_options=['parquet']
    )