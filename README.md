# A stripped down builder of Linux images for Lean

Make sure that you're logged in (docker login)

To build and push docker image, all you need to do is:

1. docker build -t %name% . -m 16g
2. docker tag %name% cs2120/leanenv
3. docker push cs2120/leanenv
