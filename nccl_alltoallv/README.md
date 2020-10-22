## Requirements ##
* 2 GPU on a system

## Run ##
```bash
$ mpirun  -np 2 --allow-run-as-root  ./nccl_alltoallv
```

## Reference ##
* [Fast Multi-GPU collectives with NCCL](https://developer.nvidia.com/blog/fast-multi-gpu-collectives-nccl/)
* [NVIDIA Collective Communication Library (NCCL) Documentation](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/index.html)
