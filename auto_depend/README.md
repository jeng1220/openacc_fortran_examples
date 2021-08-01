## Automatic Dependency ##
This example demonstrates the basic Cmake usage. The Cmake has the automatic dependency solution. The developers don't need to manually setup compiling dependency. In this example, `bar.f90` depends on `foo.f90` and Cmake knows that foo need to be compiled before bar.

## Requirements ##
* [Cmake 3.8+](https://cmake.org/download/)
* [HPC SDK](https://developer.nvidia.com/nvidia-hpc-sdk-downloads)

## Build ##
```sh
$ mkdir build && cd build
$ cmake ..
$ make
```