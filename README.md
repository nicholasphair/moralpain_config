# Peirce Docker Builder

To build and push docker image, all you need to do is:

1. docker build -t %name% . --m 16g
2. docker tag %name% andrewe8/peirce_docker
3. docker push andrewe8/peirce_docker
