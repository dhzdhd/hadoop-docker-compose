# Hadoop docker setup

## About

A Docker compose setup for the following tools
- Hadoop
- Pig
- HBase
- Hive
- Spark
- ZooKeeper (startup by init-extra)
- Mahout (startup by init-extra)
- Kafka (startup by init-extra)

Currently only consists of one master node. (Which is enough to run programs)

## Credit

Derived from the [docker-hadoop repo](https://github.com/silicoflare/docker-hadoop)

## Setup

- Windows
  1. Install [Docker desktop](https://docs.docker.com/desktop/install/windows-install/).
  2. Run Docker desktop to start the Docker engine
  3. Clone the [repository](https://github.com/dhzdhd/hadoop-docker-compose.git) locally (`git clone <url>`)
  4. `cd <cloned_repo_directory>`
  5. If you are using the terminal
     1. Run `./run.ps1` in the repository root directory.
     2. Run `init`
  6. If you want to use Docker desktop UI instead
     1. Run `exit`
     2. Open Docker desktop UI and start the container (run button)
     3. Click on the container named `master`
     4. Head on to the `Exec` tab
     5.  Run the following in the terminal displayed
         - `bash`
         - `init`
  7. Test Hadoop commands to verify successful build.
- Linux
  1. Install [Docker engine](https://docs.docker.com/engine/install/).
  2. Follow the [Post Installation Steps (Configure Docker to start on boot only)](https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot-with-systemd).
  3. Clone the [repository](https://github.com/dhzdhd/hadoop-docker-compose.git) locally (`git clone <url>`)
  4. `cd <cloned_repo_directory>`
  5. Run `chmod 777 ./run.sh` in the repository root directory.
  6. Run `./run.sh`
  7. Run `init`
  8. Test Hadoop commands to verify successful build.
- Read the `Post install` section

## Post install

1. `cd <cloned_repo_directory>`
2. Run `./run.ps1` or `./run.sh` depending on your platform.
3. Run `init`.

## Setup Extra (only if you need Mahout & Kafka)

- Run the above steps but use `init-extra` instead of `init`

## Note

### Data loss

- The current configuration does not store any data on HDFS/HBase. Please backup everything you create in the `/workdir` directory which is directly mapped to your system.

### Hive MetastoreSessionClient error

- Hive should always be started from the `/` directory (root)
- When you enter the container, the default directory is the root directory
- Starting Hive from any other directory causes the metastore to get corrupted

### Any sort of Hadoop error (MapReduce/Hive/HBase)

- Exit the container (`exit`), `./run.ps1`|`.run.sh` and `init`

### Pig takes way too much time and produces errors in mapreduce mode

- Start the job history server with `mapred historyserver &` (press enter to exit the logs)
- Run pig in mapreduce mode as normal

### ./run.ps1 not recognised as a command (Windows only)

- This error occurs when you are using command prompt
- run.ps1 is a PowerShell file and hence should be run with PowerShell only

### run.ps1 cannot be loaded because running scripts is disabled on this system (Windows only)

- Enable running foreign scripts in `Developer Settings` in the Settings application.
- Refer to the net for more information.

### Hadoop errors out after `restart`

- `restart` has been deprecated
- Simply run `exit`, `./run.ps1`|`.run.sh` and `init`

### Error on container build (download step)

- Your workplace/institute has probably blocked a link used to download one of the Hadoop tools.
- Connect to your local internet/hotspot to continue building.

### Accessing your files for backup/host usage

- The `/workdir` directory in the container is linked to `<cloned_repo_directory>/workdir` on the host
- Any files you want to access on the host have to be saved/moved to `/workdir`

### Accessing HDFS through URL

- You can access HDFS through the URL - `hdfs://master:9000`
- For example
  - `hadoop fs -ls /` is equivalent to `hadoop fs -ls hdfs://master:9000/`

### Accessing the web UI

- Access the web interfaces at `localhost:8088` and `localhost:9870`
- Port `9000` is also exposed to host but cannot and should not be accessed
