# A stripped down builder of Linux images for Lean Prover

Make sure that you're logged in (docker login)

To build and push docker image, all you need to do is:

```
docker build -t kevinsullivan/clean_lean:leanvm . -m 16g
docker push kevinsullivan/clean_lean:leanvm
```