# Simple OpenACC Fortran Examples #
Author: Jeng Bai-Cheng(rjeng@nvidia.com)

An example code is worth a thousand words. This repository intends to host fundamental, but useful examples. Each example is just a few dozen lines of code. Most of them come from my past experience in HPC projects, but readers do not need to have the HPC background to understand the examples.

## Eexamples ##
### Basic ###
* [acc_async](/acc_async) - faster way to enqueue GPU routines(kernels)
* [access_efficiency](/access_efficiency) - faster way to access a GPU arrary
* [alternative_nested_parallelism](/alternative_nested_parallelism) - alternative to nested parallelism on the GPU
* [array_setting](/array_setting) - faster way to initialize a GPU array 
* [atomic_op](/atomic_op) - use atomic operation to maximize parallelism
* [cuda_c_binding](/cuda_c_binding) - call CUDA C from Fortran
* [cuda_graph](/cuda_graph) - faster way to launch GPU kernels
* [device_routine](/device_routine) - usage of GPU routine. Call other routines in the GPU kernel
* [device_variable](/device_variable) - usage of GPU variable. Access a global variable from other modules in the GPU kernel 
* [hybrid_omp_acc](/hybrid_omp_acc) - usage of OpenMP and OpenACC

### MPI ###
* [cuda_mpi_sendrecv](/cuda_mpi_sendrecv) - CUDA-Aware MPI, faster way to use MPI on GPU
* [cuda_unified_memory_mpi_bcast](/cuda_unified_memory_mpi_bcast) - usage of CUDA Unified Memory and MPI, more convenient way to use MPI on GPU
* [nccl_alltoall](/nccl_alltoall) - faster Alltoall on GPU
* [nccl_alltoallv](/nccl_alltoallv) - faster Alltoallv on GPU

### Profiling ###
* [auto_nvtx](/auto_nvtx) - use compiler to insert CPU profiling routines automatically
* [profiling_range](/profiling_range) - demonstration of focused profiling via profiling tool

## Requirement ##
* NVIDIA HPC SDK 21.3

To install HPC SDK via Docker, visit NVIDIA GPU Cloud: https://ngc.nvidia.com/catalog/containers/nvidia:nvhpc/tags

Or download HPC SDK from official website: https://developer.nvidia.com/hpc-sdk

## Bulid ##
```sh
$ cd <folder>
$ make
```

## Run ##
```sh
$ cd <folder>
$ ./<executable>
```
