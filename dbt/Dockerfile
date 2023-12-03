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

# Set the working directory to /app

# Set environment variables
ENV PYTHON_USERNAME=username
ENV PYTHON_PASSWORD=password
ENV PYTHON_CONNECTSTRING=connect_string

# Define the default command to run when the container starts
# CMD ["python3", "script.py"]

WORKDIR /usr/app/dbt/
