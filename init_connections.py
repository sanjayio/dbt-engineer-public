#!/usr/bin/env python3
import yaml
import subprocess
import sys
import time
import os

def load_airflow_settings():
    """Load connections from airflow_settings.yaml"""
    try:
        with open('/usr/local/airflow/airflow_settings.yaml', 'r') as file:
            settings = yaml.safe_load(file)
        return settings.get('airflow', {}).get('connections', [])
    except FileNotFoundError:
        print("❌ airflow_settings.yaml not found")
        return []
    except yaml.YAMLError as e:
        print(f"❌ Error parsing airflow_settings.yaml: {e}")
        return []

def create_connection(conn_config):
    """Create an Airflow connection using the CLI"""
    conn_id = conn_config.get('conn_id')
    if not conn_id:
        print("⚠️  Skipping connection without conn_id")
        return False
    
    cmd = ["airflow", "connections", "add", conn_id]
    
    # Add connection parameters
    if conn_config.get('conn_type'):
        cmd.extend(["--conn-type", conn_config['conn_type']])
    if conn_config.get('conn_host'):
        cmd.extend(["--conn-host", conn_config['conn_host']])
    if conn_config.get('conn_schema'):
        cmd.extend(["--conn-schema", conn_config['conn_schema']])
    if conn_config.get('conn_login'):
        cmd.extend(["--conn-login", conn_config['conn_login']])
    if conn_config.get('conn_password'):
        cmd.extend(["--conn-password", conn_config['conn_password']])
    if conn_config.get('conn_port'):
        cmd.extend(["--conn-port", str(conn_config['conn_port'])])
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        print(f"✅ Successfully created connection: {conn_id}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to create connection {conn_id}: {e.stderr}")
        return False

def wait_for_airflow():
    """Wait for Airflow to be ready"""
    print("⏳ Waiting for Airflow to be ready...")
    max_attempts = 30
    attempt = 0
    
    while attempt < max_attempts:
        try:
            result = subprocess.run(
                ["airflow", "db", "check"], 
                capture_output=True, 
                text=True, 
                timeout=10
            )
            if result.returncode == 0:
                print("✅ Airflow is ready!")
                return True
        except (subprocess.TimeoutExpired, subprocess.CalledProcessError):
            pass
        
        attempt += 1
        print(f"⏳ Attempt {attempt}/{max_attempts}...")
        time.sleep(2)
    
    print("❌ Airflow did not become ready in time")
    return False

def main():
    """Main function to set up connections"""
    print("🔧 Setting up Airflow connections from airflow_settings.yaml...")
    
    # Wait for Airflow to be ready
    if not wait_for_airflow():
        sys.exit(1)
    
    # Load connections from YAML
    connections = load_airflow_settings()
    
    if not connections:
        print("⚠️  No connections found in airflow_settings.yaml")
        sys.exit(0)
    
    print(f"📋 Found {len(connections)} connections to create")
    
    success_count = 0
    for conn in connections:
        if create_connection(conn):
            success_count += 1
    
    print(f"\n📊 Summary: {success_count}/{len(connections)} connections created successfully")
    
    if success_count == len(connections):
        print("✅ All connections created successfully!")
        sys.exit(0)
    else:
        print("⚠️  Some connections failed to create")
        sys.exit(1)

if __name__ == "__main__":
    main() 