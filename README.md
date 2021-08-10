# Ubuntu 20.04 with Lean Prover and mathlib

This directory supports building of a docker
image for using the Lean Prover with mathlib
on an Ubunty 20.04 platform, and pushing it 
to DockerHub (a commercial image registry) so
that others can pull it, exec it, and use it
through VSCode to develop logic/code in Lean. 

Here are the commands needed to buid, push
(to DockerHub), and use our container. We
assume you've already got docker running on
your computer. Make sure that you're logged
in to DockerHub. 

## For developers of this image
### Build image from Dockerfile

To build a new version of the clean_lean image, run
the following command in a terminal with this directory
as the current working directory:
``` sh
docker build -t kevinsullivan/clean_lean:latest . -m 8g
```
The repository name of the image is kevinsullivan/clean_lean.
It will have the tag, *latest*.

### Push image to DockerHub

To push a copy of this image to dockerhub, do this:
``` sh
docker push kevinsullivan/clean_lean
```

## For users of this image
### Pull image from DockerHub
To pull a copy of the image to your local host machine, run: 
```sh
docker pull kevinsullivan/clean_lean
```

### Start container
To launch a container using this image run the following command.
Replace %source_directory_on_host% with the host directory you want 
the VM to access as /dm.
```
docker run -it --cap-add=SYS_PTRACE --rm --security-opt seccomp=unconfined \
    --name lean -v %source_directory_on_host%:/dm kevinsullivan/clean_lean \
    /bin/bash
```

### Get terminal into container
To connect to a terminal shell into the VM, do this:
``` sh
docker exec -it lean /bin/bash
```

### Stop running container
To stop a container from a terminal on your host machine, do this:
``` sh
docker stop lean
```
To stop a running image from a terminal into the container, exit the terminal process:
``` sh
exit
```