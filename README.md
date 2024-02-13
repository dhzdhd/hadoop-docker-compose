# Hadoop docker setup

## About

A Hadoop, Spark, Pig, Hive and HBase setup in docker compose.
Currently only consists of one master node.

## Credit

Derived from the [docker-hadoop repo](https://github.com/silicoflare/docker-hadoop)

## Setup

- Windows
  1. Install docker.
  2. Run docker desktop to start the engine
  3. Clone the repository locally
  4. Run `./run.ps1` in the repository root directory.
  5. Run `docker exec -it <container> /bin/bash` where `<container>` is the output of the previous step.
  6. Inside the container that you just opened, run `init`
- Docker desktop interface
  1. Follow step 1, 2, 3 and 4 from above
  2. Open docker desktop and click on the container named `master`
  3. Head on to the `Exec` tab
  4. Run the following
    - `bash`
    - `init`

## Post install

1. Follow step 4 and 5 from `Setup > Windows`
2. Now, instead of running `init` inside the container shell, run `restart`

## Usage

- Use Hadoop as normal after setting up and entering the container.
- Access the web interfaces at `localhost:8088` and `localhost:9870`
- Once done, type `exit` twice to exit the container.
- Run `docker compose down` to shutdown the container.
