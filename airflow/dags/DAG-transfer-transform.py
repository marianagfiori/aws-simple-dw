# primeira task: sensor que sente um novo arquivo no bucket raw (baseado na última modificação do arquivo (tem que ser do dia atual))
# segunda task: chama o glue job para fazer o pre-processamento dos arquivos novos

from airflow import DAG
from airflow.providers.amazon.aws.sensors.s3 import S3KeySensor
from airflow.providers.amazon.aws.operators.glue_crawler import GlueCrawlerOperator
from airflow.providers.amazon.aws.operators.glue import AWSGlueJobOperator
from datetime import datetime, timedelta
from functools import partial

default_args = {
    'owner': 'Mariana',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
    'start_date':datetime(2023, 5, 4)
}

aws_connection = 'aws-connection-s3-simple-dw-project1'
s3_bucket='olist-project-dw'

#verifica se o arquivo foi adicionado no dia atual

def check_new_files(s3_key, *args):
  bucket = s3.Bucket(s3_bucket)
  prefix_objs = bucket.objects.filter(Prefix=s3_key)
  current_day = datetime.today().strftime("%Y-%m-%d")
  for obj in prefix_objs:
    obj = obj.last_modified.strftime("%Y-%m-%d")
    if obj == current_day:
      print(True)
      return True
    else:
      print(False)
      continue

with DAG (
    default_args=default_args,
    dag_id="DAG-aws-simple-dw",
    description="DAG that catch the data from the 'raw' bucket, catalogs it and calls a Glue Job responsible for the cleaning.",
    schedule_interval=timedelta(days=1),

) as dag1:
  
  s3_key_raw = 'raw/'
  s3_key_curated = 'curated/'
  check_new_files_partial = partial(check_new_files, s3_key_raw)

  sensor_raw_task = S3KeySensor(
     task_id = "s3_raw_arquivos_novos_check",
     bucket_name = s3_bucket,
     bucket_key=s3_key_raw,
     wildcard_match=True,
     aws_conn_id=aws_connection,
     poke_interval=60,
     timeout=1800,
     check_fn=check_new_files_partial
    )

  crawler_raw_task = GlueCrawlerOperator(
     task_id="cataloga_tabelas_raw",
     aws_conn_id=aws_connection,
     config = {
              'Name':'olist-raw-ingest',
              'Role':'olist-dw-project',
              'DatabaseName':'olist-project-raw',
              'Targets':{'S3Targets':[{'Path':'s3://olist-project-dw/raw/'}]}
      },
     region_name="us-east-1",
     wait_for_completion=True
  )

  job_raw_task = AWSGlueJobOperator(
    task_id='trigger_raw_job',
    job_name='raw-job',
    aws_conn_id=aws_connection,
    region_name='us-east-1'
  )
  
  s3_key_cleaned = 'cleaned/'
  check_new_files_partial(check_new_files, s3_key_cleaned)

  sensor_cleaned_task = S3KeySensor(
    task_id = "s3_cleaned_arquivos_novos_check",
    bucket_name = s3_bucket,
    bucket_key= s3_key_cleaned,
    wildcard_match=True,
    aws_conn_id=aws_connection,
    poke_interval=60,
    timeout=1800,
    check_fn=check_new_files_partial 
  )

  crawler_cleaned_task = GlueCrawlerOperator(
    task_id="cataloga_tabelas_cleaned",
    aws_conn_id=aws_connection,
    config={
              'Name':'olist-cleaned-ingest',
              'Role':'olist-dw-project',
              'DatabaseName':'olist-project-cleaned',
              'Targets':{'S3Targets':[{'Path':'s3://olist-project-dw/cleaned/'}]}
      },
    region_name="us-east-1",
    wait_for_completion=True
  )

  job_cleaned_task = AWSGlueJobOperator(
    task_id='trigger_cleaned_job',
    job_name='cleaned-job',
    aws_conn_id=aws_connection,
    region_name='us-east-1'
  )

sensor_raw_task >> crawler_raw_task >> job_raw_task >> sensor_cleaned_task >> crawler_cleaned_task >> job_cleaned_task

