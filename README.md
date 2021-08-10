# Ubuntu 20.04 with Lean Prover and mathlib

This directory supports building of a docker
image for using the Lean Prover with mathlib
on an Ubunty 20.04 platform, and pushing it 
to DockerHub (a commercial image registry). 

The container specified here minimally extends
Ubuntu with what's needed and no more to provide
a containerized environment for using VS Code
to develop Lean on any computer running docker.

The rest of this document explains the basic
docker commands you will use in relation in 
this project. We assume you've already got
docker running on your computer. Make sure 
you're logged in to DockerHub for all of the
instructions here to work. 

## Build image from Dockerfile

To build a new version of the clean_lean image, run
the following command in a terminal with this directory
as the current working directory:
``` sh
docker build -t kevinsullivan/clean_lean:latest . -m 8g
```
The repository name of the image is kevinsullivan/clean_lean.
It will have the tag, *latest*.

## Push image to DockerHub

To push a copy of this image to dockerhub, do this:
``` sh
docker push kevinsullivan/clean_lean
```

## Pull image from DockerHub
To pull a copy of the image to your local host machine, run: 
```sh
docker pull kevinsullivan/clean_lean
```

## Start container
To launch a container using this image run the following command.
Replace %source_directory_on_host% with the host directory you want 
the VM to access as /dm.
```
docker run -it --cap-add=SYS_PTRACE --rm --security-opt seccomp=unconfined \
    --name lean -v %source_directory_on_host%:/dm kevinsullivan/clean_lean \
    /bin/bash
```

## Get terminal into container
To connect to a terminal shell into the VM, do this:
``` sh
docker exec -it lean /bin/bash
```

## Stop running container
To stop a container from a terminal on your host machine, do this:
``` sh
docker stop lean
```
To stop a running image from a terminal into the container, exit the terminal process:
``` sh
exit
```