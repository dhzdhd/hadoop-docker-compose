#! /usr/bin/bash

echo "Starting up container"
sudo docker compose up -d
sudo docker exec -it master /bin/bash

echo "Exiting container"
sudo docker compose down
