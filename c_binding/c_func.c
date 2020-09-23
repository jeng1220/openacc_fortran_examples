#include <stdio.h>

void my_c_func(int *buf, int *wptr, int *hptr)
{
  int h = *hptr;
  int w = *wptr;

  printf("print from c, w=%d, h=%d\n", w, h);

  for (int x = 0; x < w; ++x) {
    for (int y = 0; y < h; ++y) { 
      printf("%d, ", buf[ x * h + y ]);
    }
    printf("\n");
  }
  printf("\n");

  #pragma acc parallel loop copy(buf[w*h])
  for (int x = 0; x < w; ++x) {
    #pragma acc loop
    for (int y = 0; y < h; ++y) { 
      buf[ x * h + y ] += 1;
    }
  }

  return;
}
