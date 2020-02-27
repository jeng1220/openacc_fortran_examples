# Fortran Study #

## bulid ##
```sh
$ make
```

## run ##
```sh
$ nsys profile -t cuda,openacc ./openacc_nested_loop
$ PGI_ACC_BUFFERSIZE=134217728 nsys profile -t cuda,openacc ./openacc_nested_loop

$ LD_PRELOAD=libnvtx_pmpi.so mpirun -np 2 nsys profile -t mpi,nvtx ./mpi_basic

$ nsys profile -t cuda,openacc ./cuda_graph

$ nsys profile -t cuda,openacc ./async

$ nsys profile -t cuda,openacc ./parallel_call
```
