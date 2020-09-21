program main
  use cudafor
  use openacc
  implicit none

  integer :: i, n, istat
  integer(kind=cuda_stream_kind) :: my_stream
  integer, allocatable :: a(:)
  type(cudaGraph) :: graph
  type(cudaGraphExec) :: graph_exec
  type(cudaGraphNode) :: error_node
  character(c_char) :: buffer
  integer(c_size_t) :: buffer_len
  real :: start, finish

  n = 1024
  allocate(a(n))
  !$acc enter data create(a(n))

  ! Normal version:
  call cpu_time(start)
  do n = 1,1000
    !$acc parallel loop present(a(n)) async(1) 
    do i = 1, 1024
      a(i) = a(i) + 1
    end do
  end do
  !$acc wait(1)
  call cpu_time(finish)
  print '("Normal Kernel Launch time = ",f6.3," seconds.")', (finish - start) 


  ! CUDA Graph version:
  ! Capture only, NO kerenl execution
  istat = cudaStreamCreateWithFlags(my_stream, cudaStreamNonBlocking)
  call acc_set_cuda_stream(1, my_stream)

  istat = cudaStreamBeginCapture(my_stream, cudaStreamCaptureModeGlobal)
  do n = 1,1000
    !$acc parallel loop present(a(n)) async(1) 
    do i = 1, 1024
      a(i) = a(i) + 1
    end do
  end do
  istat = cudaStreamEndCapture(my_stream, graph)

  ! Execute CUDA Graph
  buffer_len = 0
  istat = cudaGraphInstantiate(graph_exec, graph, error_node, buffer, buffer_len)
  call cpu_time(start)
  istat = cudaGraphLaunch(graph_exec, my_stream)
  istat = cudaStreamSynchronize(my_stream)
  call cpu_time(finish)
  print '("CUDA Graph time = ",f6.3," seconds.")', (finish - start)

  !$acc exit data delete(a)
  deallocate(a)
end program
