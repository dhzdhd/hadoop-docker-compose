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
