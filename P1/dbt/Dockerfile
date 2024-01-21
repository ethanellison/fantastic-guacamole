# Use an official Oracle Instant Client image as a parent image
FROM python:3.10.7-slim-bullseye 
# system startup
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
  git \
  ssh-client \
  software-properties-common \
  make \
  build-essential \
  ca-certificates \
  libpq-dev \
  && apt-get clean \
  && rm -rf \
  /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/*


RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir
RUN python -m pip install oracledb --upgrade

RUN python -m pip install dbt-oracle --upgrade

# Get variables from .env
ARG WALLET_PASSWORD
ARG DBT_ORACLE_USER
ARG DBT_ORACLE_PASSWORD
ARG DBT_ORACLE_SCHEMA
ARG DBT_ORACLE_HOST
ARG DBT_ORACLE_SERVICE
ARG DBT_ORACLE_DATABASE
ARG DBT_ORACLE_TNS_NAME
# Set environment variables
ENV ORA_PYTHON_DRIVER_TYPE=thin
ENV WALLET_LOCATION=/usr/.config
ENV WALLET_PASSWORD=${WALLET_PASSWORD}
ENV TNS_ADMIN=/usr/.config

ENV DBT_ORACLE_USER=${DBT_ORACLE_HOST}
ENV DBT_ORACLE_PASSWORD=${DBT_ORACLE_PASSWORD}
ENV DBT_ORACLE_SCHEMA=${DBT_ORACLE_SCHEMA}
ENV DBT_ORACLE_HOST=${DBT_ORACLE_HOST}
ENV DBT_ORACLE_SERVICE=${DBT_ORACLE_SERVICE}
ENV DBT_ORACLE_DATABASE=${DBT_ORACLE_DATABASE}
ENV DBT_ORACLE_TNS_NAME=${DBT_ORACLE_TNS_NAME}


# Define the default command to run when the container starts
# CMD ["python3", "script.py"]

# Set the working directory to /app
WORKDIR /usr/app/dbt_adb
