# A stripped down builder of Linux images for Lean Prover

Make sure that you're logged in (docker login)

To build a new version of the clean_lean image, run
the following command in a terminal with this directory
as the current working directory:
``` sh
docker build -t kevinsullivan/clean_lean:latest . -m 8g
```
The repository name of the image is kevinsullivan/clean_lean.
It will have the tag, *latest*.

To push a copy of this image to dockerhub, do this:
``` sh
docker push kevinsullivan/clean_lean
```

To pull a copy of the image to your local host machine, run: 
```sh
docker pull kevinsullivan/clean_lean
```

To launch a container using this image:
```
docker run -it --cap-add=SYS_PTRACE --rm --security-opt seccomp=unconfined \
    --name lean -v %source_directory_on_host%:/dm kevinsullivan/clean_lean \
    /bin/bash
```
Replace %source_directory_on_host% with the directory that you want open in
the VM as the directory, /dm.

To connect to a terminal shell into the VM, do this:
``` sh
docker exec -it lean /bin/bash
```

To stop a running image, from a terminal on your host machine, do
``` sh
docker stop lean
```
or issue the *exit* shell command from a terminal from the VM.


