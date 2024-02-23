FROM ubuntu:latest as base

# Set environment variables for Hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV PATH $HADOOP_HOME/bin:$PATH
ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_NODEMANAGER_USER=root
ENV YARN_RESOURCEMANAGER_USER=root

# Install necessary dependencies
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:maveonair/helix-editor
RUN apt update && \
    apt install -y ssh openjdk-8-jdk neovim helix junit python-is-python3 nano curl python3-pip

# Download and extract Hadoop
RUN mkdir -p $HADOOP_HOME && \
    wget -O hadoop.tar.gz https://downloads.apache.org/hadoop/common/stable/hadoop-3.3.6.tar.gz && \
    tar -xzvf hadoop.tar.gz -C $HADOOP_HOME --strip-components=1

# Configure SSH
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

RUN wget -O /usr/local/hadoop/lib/javax.activation-api-1.2.0.jar https://jcenter.bintray.com/javax/activation/javax.activation-api/1.2.0/javax.activation-api-1.2.0.jar

RUN mkdir -p /home/hadoop/hdfs/{namenode,datanode} && \
    chown -R $USER:$USER /home/hadoop/hdfs

# Hadoop configuration
COPY config/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY config/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY config/hadoop/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY config/hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc && \
    echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc && \
    echo "export HADOOP_INSTALL=\$HADOOP_HOME" >> ~/.bashrc && \
    echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >> ~/.bashrc && \
    echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >> ~/.bashrc && \
    echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" >> ~/.bashrc && \
    echo "export YARN_HOME=\$HADOOP_HOME" >> ~/.bashrc && \
    echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin" >> ~/.bashrc && \
    echo "export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib/native\"" >> ~/.bashrc

RUN echo "HDFS_NAMENODE_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "HDFS_DATANODE_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "HDFS_SECONDARYNAMENODE_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "YARN_NODEMANAGER_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "YARN_RESOURCEMANAGER_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "export HADOOP_CLASSPATH+=\" \$HADOOP_HOME/lib/*.jar\"" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

# Install pig
RUN wget -O pig.tar.gz https://downloads.apache.org/pig/pig-0.17.0/pig-0.17.0.tar.gz && \
    tar -xzvf pig.tar.gz && \
    mv pig-0.17.0 /pig && \
    echo "export PIG_HOME=/pig" >> ~/.bashrc && \
    echo "export PATH=\$PATH:/pig/bin" >> ~/.bashrc && \
    echo "export PIG_CLASSPATH=\$HADOOP_HOME/etc/hadoop" >> ~/.bashrc

# Install hbase
RUN wget http://apache.mirror.gtcomm.net/hbase/stable/hbase-2.5.7-bin.tar.gz && \
    tar -xzvf hbase-2.5.7-bin.tar.gz && \
    mv hbase-2.5.7 /usr/local/hbase && \
    echo "export HBASE_HOME=/usr/local/hbase" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$HBASE_HOME/bin" >> ~/.bashrc && \
    echo "export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP=\"true\"" >> /usr/local/hbase/conf/hbase-env.sh && \
    echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> /usr/local/hbase/conf/hbase-env.sh
COPY config/hadoop/hbase-site.xml ~/hbase-site.xml

# RUN mkdir -p /hadoop/zookeeper && \
#     chown -R $USER:$USER /hadoop/

# Install Hive
RUN wget https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz && \
    tar -xzvf apache-hive-3.1.3-bin.tar.gz && \
    mv apache-hive-3.1.3-bin /usr/local/hive && \
    echo "export HIVE_HOME=/usr/local/hive" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$HIVE_HOME/bin" >> ~/.bashrc && \
    echo "HADOOP_HOME=/usr/local/hadoop" >> /usr/local/hive/bin/hive-config.sh

# Install Spark
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y scala git && \
    wget https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz && \
    tar -xf spark-3.4.1-bin-hadoop3.tgz && \
    mv spark-3.4.1-bin-hadoop3 /usr/local/spark && \
    echo "export SPARK_HOME=/usr/local/spark" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin" >> ~/.bashrc

# Install Pyspark
RUN pip install pyspark

# Copy init and restart scripts
COPY config/restart $HADOOP_HOME/bin/restart
COPY config/init $HADOOP_HOME/bin/init
COPY config/colors $HADOOP_HOME/bin/colors
RUN chmod +x $HADOOP_HOME/bin/restart && \
    chmod +x $HADOOP_HOME/bin/colors && \
    chmod +x $HADOOP_HOME/bin/init

# Cleaning up archives
RUN rm *.tar.gz && \
    rm *.tgz

# Remove code in .bashrc
RUN sed -i 5,7d ~/.bashrc

# Add custom config to Helix
COPY config/helix/config.toml ~/.config/helix/config.toml

# Download LSP for Python, Scala
RUN apt install python3-pylsp -y
RUN curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs && \
    chmod +x cs && \
    ./cs setup -y && \
    ./cs install metals && \
    echo export PATH="$PATH:/root/.local/share/coursier/bin" >> ~/.bashrc

# Expose necessary ports
EXPOSE 9870 8088 9000

FROM base as master

EXPOSE 9870 8088 9000

CMD ["python3", "-m", "http.server"]
