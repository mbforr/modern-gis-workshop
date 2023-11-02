# Create a Python virtual environment

python3 -m venv dbt-env  

# Activate the virtual environment

source dbt-env/bin/activate

# Install the dbt-core package

pip install dbt-core

# Install the DuckDB dbt package

pip install dbt-duckdb

# Check that dbt is installed correctly

dbt --version

# Start a project named "storm_events"

dbt init storm_events

# Navigate into that folder

cd storm_events

# All the files should be installed. 

# 1. At this point you should open the storm_events/models/example/my_first_dbt_model.sql
# and replace it with the code in 4-dbt/my_first_dbt_model.sql

# 2. Next delete the file storm_events/models/example/my_second_dbt_model.sql and remove lines 13 to 22 from storm_events/models/example/schema.yml

# 3. Add the 4-dbt/schema.yml and 4-dbt/sources.yml files into storm_events/models/example and remove any files of the same name before transfering them

# 4. Add 4-dbt/profiles.yml into the main storm_events folder

# Then run the below command to make sure all checks are working


dbt debug

# If all checks succeed, then run the model using this command

dbt run