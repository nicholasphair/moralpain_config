# Peirce Docker Builder

To build and push docker image, all you need to do is:

docker build -t %name% . --m 16g
docker tag %name% andrewe8/peirce_docker
docker push andrewe8/peirce_docker
