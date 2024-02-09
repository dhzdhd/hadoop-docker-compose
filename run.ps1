docker compose up -d

$container = docker container ls --all --quiet --filter "name=master"
Write-Output $container
