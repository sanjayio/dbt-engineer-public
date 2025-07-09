# DBT Engineer Public

The official public repo with code examples mentioned in dbtengineer.com. 

## Local Development

This repo is for locally working with Airflow and DBT Core, with Postgres backend. The instructions here are meant for Postgres backend, but you can use any backend of your choice. 

### Prerequisites

1. Docker desktop
2. Python 3.12 or higher

### Setup

1. Clone this repo. 
2. Create a `data` folder in the root folder on your local. 
3. Rename `.env-example` to `.env` and create new values for all missing values. Instructions to create the fernet key at the end of this Readme. 
4. Rename `airflow_settings-example.yaml` to `airflow_settings.yaml` and  use the values you created in `.env` to fill missing values in `airflow_settings.yaml`.
5. Rename `servers-example.json` to `servers.json` and update the `host` and `username` values to the values you set above. 

### Running Locally

1. Run `docker compose up` and wait for containers to spin up. This could take a while. 
2. Access Airflow web interface at `localhost:8080`.
3. Access pgAdmin web interface at `localhost:16543`.

### Cleanup

Run Ctrl + C or Cmd + C to stop containers, and then `docker compose down`. 

## Misc

### How to generate fernet key

```sh
python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
```

