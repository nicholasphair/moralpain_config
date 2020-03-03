echo 1
cd /root
curl https://raw.githubusercontent.com/Kha/elan/master/elan-init.sh -sSf | sh -s -- -y
curl -L https://github.com/leanprover/lean/releases/download/v3.4.2/lean-3.4.2-linux.tar.gz > lean.tar.gz
gunzip lean.tar.gz
tar -xvf lean.tar
cd lean-3.4.2-linux
cp -r bin/ /usr/
cp -r lib/ /usr/
cp -r include/ /usr/
cd ..
rm -rf lean.tar
rm -rf lean-3.4.2-linux

curl https://raw.githubusercontent.com/kevinsullivan/phys/master/src/orig/vec.lean > vec.lean

git clone https://github.com/leanprover-community/mathlib.git
git clone https://github.com/kevinsullivan/dm.s20.git
cd mathlib
git checkout --detach 05457fdd93d4d12b6d897e174639d81d393c8d8b
cd ../dm.s20
leanpkg configure
leanpkg build
cd ..
mv mathlib mathlib_uncompiled
mv dm.s20/_target/deps/mathlib mathlib

# If the LLVM build folder doesn't exist yet, create it.
if [[ ! -d /llvm/build ]]; then 
  echo '===---------- Creating /llvm/build folder ----------==='
  mkdir -p /llvm/build
fi

# Find out what clang is called on here.
which clang++-3.9
if [[ $? -eq 0 ]]; then
  export CXX=clang++-3.9
else
  export CXX=clang++
fi
                           
# If the folder is empty, build it.
echo '===---------- Building LLVM and clang ----------==='
cd /llvm/build

cmake -G 'Ninja' -DCMAKE_BUILD_TYPE=Release -DCLANG_ENABLE_BOOTSTRAP=On -DCMAKE_C_COMPILER=$C -DCMAKE_CXX_COMPILER=$CXX -LLVM_USE_LINKER=gnu.ld -LLVM_PARALLEL_LINK_JOBS=1 -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_EH=ON ..

ninja stage2

#-DCMAKE_INSTALL_PREFIX="/usr/bin/gcc" 

cmake --build . 

#cmake -DCMAKE_BUILD_TYPE=MinSizeRel \
#      -DLLVM_ENABLE_ASSERTIONS=OFF \
#      -DCMAKE_C_COMPILER=$C \
#      -DCMAKE_CXX_COMPILER=$CXX \
#      ..
#make -j4
cmake install

cd -

#first install elan
#then curl lean
#



# If the project build folder doesn't exist yet, create it.
#if [[ ! -d /User/isprime/peirce/build ]]; then
#  echo '===---------- Creating /build folder ----------==='
#  mkdir /User/isprime/peirce/build
#fi

# If the folder is empty, build it.
#echo "===---------- Building project on $1 ----------==="
#cd /User/isprime/peirce/build
#cmake -DLLVM_PATH=/llvm \
#      -DCMAKE_BUILD_TYPE=MinSizeRel \
#      -DCMAKE_C_COMPILER=$C \
#      -DCMAKE_CXX_COMPILER=$CXX \
#      -DFIND_LLVM_VERBOSE_CONFIG=on \
#      -DCLANG_EXPAND_OS_NAME=$1 \
#      /User/isprime/peirce/project
#make -j4
#cd -
