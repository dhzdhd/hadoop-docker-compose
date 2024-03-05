#! /usr/bin/bash

sudo docker compose up -d
sudo docker exec -it master /bin/bash
sudo docker compose down
