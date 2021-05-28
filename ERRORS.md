 * Known errors in this physical module
 
- The project-wide docker launch.json file references an obscure detail in the organization of our directory structure for ros projects. Namely, the following is present in that file: "args": ["/peirce/ros_test_cases/playground/src/playground/src/transforms.cpp", "-extra-arg=-I/opt/ros/melodic/include/"],. The launch.json file will thus be invalidated by many reasonable changes to our overall project directory structure. TODO: Remove dependency.
