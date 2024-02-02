# Use an official Oracle Instant Client image as a parent image
FROM python:3.11.7-slim-bullseye 
# system startup
RUN apt-get update \
  && apt-get upgrade -y \
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


EXPOSE 8080

# Define the default command to run when the container starts
# CMD ["python3", "script.py"]

# Set the working directory to /app
WORKDIR /usr/app/dbt_adb
