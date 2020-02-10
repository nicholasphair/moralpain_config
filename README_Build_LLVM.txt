# To build LLVM/Clang for this project, cd into this llvm directory. Then
# make a build subdirectory in which to do the build, and cd into it.

mkdir build
cd build

# Next, adjust the options in the following build command (note the ..; this
# command expects to run in a build directory just below the llvm directory).
# Then run it.

cmake -G 'Ninja' -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_ENABLE_PROJECTS="clang
;clang-tools-extra;libcxx" -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON -DCMAKE_INS
TALL_PREFIX="/usr/bin/gcc" ..

# When it's done configuring the build, execute the following command
# to do the build.

cmake --build .

# To install the built software in /usr/local, where it needs to go, do this:

cmake --build . --target install

# To clean up after the build, which is important if this VM is going to be
# shared, remove the build directory and all of its contents after the install.
# NOTE: It can take several hours to do a build, so remove your build directory
# only if you're really done with it for a while.

cd ..
rm -rf build
