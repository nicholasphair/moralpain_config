# How to build moralpain for Program and Data Representation
This directory supports building of a docker image to support 
development of the moralpain_dev project.

Do not open this repo in a remote container. Open it on your local
machine, on which you'll build the VM. 

## Build image from Dockerfile

Run the following command in a terminal with this
directory as the current working directory. The
repository image name is <github-username>/moralpain.
It will have the tag, *latest*.

``` sh
docker build -t ghcr.io/<github-username>/moralpain_config:latest . -m 8g
```

## Push image to DockerHub

To push a copy of this image to an image repository
use docker push. Log in first if necessary.

``` sh
echo <GitHub PAT> | docker login ghcr.io -u myusername --password-stdin
docker push ghcr.io/<github-username>/moralpain_config:latest
```

## Pull image from DockerHub

To pull a copy of the image to your local host machine, run:

```sh
docker pull <github-username>/moralpain
ghcr.io/<github-username>/moralpain_config:main
```

## Start container

To launch a container using this image run the following command.
Replace %source_directory_on_host% with the host directory you want
the VM to access as /dm. Replace %container_name% with the name you'd
like to give to the launched docker container. We suggest giving it
a name that reflects the local directory that is mounted on its
container-local directory, /dm.

``` sh
docker run -it --cap-add=SYS_PTRACE --rm --security-opt seccomp=unconfined \
    --name %container_name% -v %source_directory_on_host%:/dm <github-username>/moralpain \
    /bin/bash
```

## Get terminal into container

To connect to a terminal shell into the VM, do this:

``` sh
docker exec -it moralpain /bin/bash
```

## Stop running container

To stop a container from a terminal on your host machine, do this:

``` sh
docker stop %container_name%
```

To stop a running image from a terminal into the container, exit the terminal process:

``` sh
exit
```
