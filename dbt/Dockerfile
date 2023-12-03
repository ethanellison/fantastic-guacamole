# Use an official Oracle Instant Client image as a parent image
FROM --platform=linux/arm64 python:3.10.7-slim-bullseye 
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


# Set environment variables
ENV ORA_PYTHON_DRIVER_TYPE=thin
ENV WALLET_LOCATION=/usr/.config
ENV WALLET_PASSWORD=Rougeetor2;
ENV TNS_ADMIN=/usr/.config

ENV DBT_ORACLE_USER=ADMIN
ENV DBT_ORACLE_PASSWORD=jexvep-3kyxZo-zirbip
ENV DBT_ORACLE_SCHEMA=ADMIN
ENV DBT_ORACLE_HOST=adb.ca-montreal-1.oraclecloud.com
ENV DBT_ORACLE_SERVICE=g499c96d8bc280d_playground_high.adb.oraclecloud.com
ENV DBT_ORACLE_DATABASE=playground

ENV DBT_ORACLE_TNS_NAME=playground_high

ENV PYTHON_USERNAME=username
ENV PYTHON_PASSWORD=password
ENV PYTHON_CONNECTSTRING=connect_string

# Define the default command to run when the container starts
# CMD ["python3", "script.py"]

# Set the working directory to /app
WORKDIR /usr/app/
