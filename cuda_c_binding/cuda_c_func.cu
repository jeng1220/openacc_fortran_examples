#include <stdio.h>
__global__ void my_gpu_func(int* buf, int w, int h) {
  int x = blockIdx.x * blockDim.x + threadIdx.x;
  int y = blockIdx.y * blockDim.y + threadIdx.y;
  if (x < w && y < h) {
    buf[y * w + x] += 1;
  }
}

extern "C"{

void my_c_func(int *buf, int *wptr, int *hptr)
{
  int h = *hptr;
  int w = *wptr;

  printf("print from c, w=%d, h=%d\n", w, h);
  for (int y = 0; y < h; ++y) {
    for (int x = 0; x < w; ++x) { 
      printf("%d, ", buf[ y * w + x ]);
    }
    printf("\n");
  }
  printf("\n");

  int *dev_buf;
  size_t size = w * h * sizeof(int);
  cudaMalloc((void**)&dev_buf, size);
  cudaMemcpy(dev_buf, buf, size, cudaMemcpyHostToDevice);

  my_gpu_func<<<1, dim3(w, h)>>>(dev_buf, w, h);

  cudaMemcpy(buf, dev_buf, size, cudaMemcpyDeviceToHost);
  cudaFree(dev_buf);
  return;
}
}
