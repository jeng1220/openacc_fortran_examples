## Requirement ##
* CUDA-Aware MPI

## Check OpenMPI version ##
```bash
$ ompi_info --parsable --all | grep mpi_built_with_cuda_support:value
```
It should return `true`

## Check OpenMPI, infiniband and CUDA for multi-node ##
```bash
$ ompi_info --all | grep btl_openib_have_cuda_gdr
$ ompi_info --all | grep btl_openib_have_driver_gdr
```
It should return `true`

## Run ##
```bash
$ mpirun -n 4 --allow-run-as-root ./cuda_mpi_allreduce
#OR:
$ mpirun -n 4 --mca btl_openib_want_cuda_gdr 1 ./cuda_mpi_allreduce
```

## Reference ##
* [An Introduction to CUDA-Aware MPI](https://developer.nvidia.com/blog/introduction-cuda-aware-mpi)
* [Benchmarking CUDA-Aware MPI](https://developer.nvidia.com/blog/benchmarking-cuda-aware-mpi)
* [Building CUDA-aware Open MPI](https://www.open-mpi.org/faq/?category=buildcuda)
* [Running CUDA-aware Open MPI](https://www.open-mpi.org/faq/?category=runcuda)
