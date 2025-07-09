#!/bin/bash

# Start Airflow in the background
airflow standalone &

# Wait for Airflow to be ready
echo "Waiting for Airflow to start..."
sleep 30

# Run the connection initialization script
echo "Setting up connections..."
python /usr/local/airflow/init_connections.py

# Keep the container running
wait 