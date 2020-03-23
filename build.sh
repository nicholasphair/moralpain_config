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

cmake --build . 