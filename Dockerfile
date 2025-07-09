FROM astrocrpublic.azurecr.io/runtime:3.0-4

# Copy requirements and install them
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Install dbt in a virtual environment in home directory
RUN python -m venv /home/astro/dbt_venv && \
  /home/astro/dbt_venv/bin/pip install --no-cache-dir dbt-postgres

# Add dbt virtual environment to PATH
ENV PATH="/home/astro/dbt_venv/bin:$PATH"

# Copy the rest of the application
COPY . /usr/local/airflow/
