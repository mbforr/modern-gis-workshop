python3 -m venv dbt-env  

source dbt-env/bin/activate

pip install dbt-core

pip install dbt-duckdb

dbt --version

dbt init storm_events

dbt debug