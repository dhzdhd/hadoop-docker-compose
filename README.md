# Hadoop docker setup

## About

A Hadoop, Spark, Pig, Hive and HBase setup in docker compose.
Currently only consists of one master node.

## Credit

Derived from the [docker-hadoop repo](https://github.com/silicoflare/docker-hadoop)

## Setup

- Windows
  - Install docker.
  - Run `./run.ps1`.
  - Run `docker exec -it <container> /bin/bash` where `<container>` is the output of the previous step.
  - Inside the container that you just opened, run
    - `bash`
    - `init`
- Docker desktop interface
  - Click on the container named `master`
  - Head on to the `Exec` tab
  - Run the following
    - `bash`
    - `init`

## Usage

- Use Hadoop as normal after setting up and entering the container.
- Access the web interfaces at `localhost:8088` and `localhost:9870`
- Once done, type `exit` twice to exit the container
- Run `docker compose down` to shutdown the container.
