from airflow import DAG
from airflow.sdk import task 
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.smtp.operators.smtp import EmailOperator
from airflow.utils.timezone import datetime
import pendulum
from datetime import timedelta

# Set the timezone to Asia/Kolkata
local_tz = pendulum.timezone("Asia/Kolkata")


# added airfow failure email notification in .env file, so that we can use it in the DAG if needed in the future
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'email_on_failure': True,
    'email': ['Nitin321x@gmail.com']
}

with DAG(
    dag_id='run_datawarehouse_procedure_taskflow',
    default_args=default_args,
    description='A DAG to run a stored procedure in Postgres and send an email notification',
    schedule='0 12 * * *',
    start_date=datetime(2024, 6, 1),
    catchup=False,
    tags=['datawarehouse', 'stored_procedure', 'email_notification']
) as dag:

    @task(task_id="run_bronze_procedure")
    def run_bronze(): 
        hook = PostgresHook(postgres_conn_id='my_postgres')
        hook.run("CALL bronze.load_bronze();")
    
    @task(task_id="run_silver_procedure")
    def run_silver():
        hook = PostgresHook(postgres_conn_id='my_postgres')
        hook.run("CALL silver.load_silver();")

    @task(task_id="run_gold_procedure")
    def run_gold():
        hook = PostgresHook(postgres_conn_id='my_postgres')
        hook.run("CALL gold.create_gold_tables();")
    
    # 4. Success email task using the modern EmailOperator
    send_success_email = EmailOperator(
        task_id='send_success_email',
        to="Nitin321x@gmail.com",
        subject="Data Warehouse ETL Success",
        html_content="<p>The ETL process for the data warehouse has completed successfully.</p>"
    )

    # Define task dependencies
    run_bronze() >> run_silver() >> run_gold() >> send_success_email
    