for container_id in $(docker ps -q); do
    docker export $container_id > $container_id.tar
done
