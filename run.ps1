Write-Output "Starting up container"
docker compose up -d
docker exec -it master /bin/bash

Write-Output "Exiting container"
docker compose down
