# Hadoop docker setup

## About

A Hadoop, Spark, Pig, Hive and HBase setup in docker compose.
Currently only consists of one master node.

## Credit

Derived from the [docker-hadoop repo](https://github.com/silicoflare/docker-hadoop)

## Setup

- Windows
  - Install docker.
  - Run docker desktop to start the engine
  - Clone the repository locally
  - Open the repository in VSCode and change the `init`, `restart` and `colors` (present in `/config`) file EOL sequences from CRLF to LF
  - Run `./run.ps1`.
  - Run `docker exec -it <container> /bin/bash` where `<container>` is the output of the previous step.
  - Inside the container that you just opened, run `init`
- Docker desktop interface
  - Follow step 1, 2, 3 and 4 from above
  - Open docker desktop and click on the container named `master`
  - Head on to the `Exec` tab
  - Run the following
    - `bash`
    - `init`

## Usage

- Use Hadoop as normal after setting up and entering the container.
- Access the web interfaces at `localhost:8088` and `localhost:9870`
- Once done, type `exit` twice to exit the container
- Run `docker compose down` to shutdown the container.
