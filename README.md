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

### Running Airflow Locally

1. Run `docker compose up` and wait for containers to spin up. This could take a while. 
2. Access pgAdmin web interface at `localhost:16543`. Create a `public` database under the postgres server. 
3. Access Airflow web interface at `localhost:8080`. Trigger the dag. 

### Running dbt Core Locally

Create a virtual env for installing dbt core

```sh
python3 -m venv dbt_venv
source dbt_venv/bin/activate
```

Optional, to create an alias

```sh
alias env_dbt='source dbt_venv/bin/activate'
```

Install dbt Core

```sh
python -m pip install dbt-core dbt-postgres
```

Confirm installation

```sh
dbt --version
```

You should get something like

```
Core:
  - installed: 1.10.3
  - latest:    1.10.3 - Up to date!

Plugins:
  - postgres: 1.9.0 - Up to date!
```

Create a `profile.yml` file in your `/Users/<yourusernamehere>/.dbt` directory and add the following content

```yaml
default:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: your-postgres-username-here
      password: your-postgres-password-here
      dbname: public
      schema: public
```

You can now run dbt commands from the dbt directory. 

```sh
cd dbt/hello_world
dbt compile
```

### Cleanup

Run Ctrl + C or Cmd + C to stop containers, and then `docker compose down`. 

## FAQs

### How to generate fernet key

```sh
python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
```

### Incorrect fernet key

Remove docker volume

```sh
docker compose down -v
```