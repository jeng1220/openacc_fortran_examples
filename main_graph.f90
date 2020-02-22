program main
  use cudafor
  use cuda_graph
  use iso_c_binding
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

  istat = cudaStreamCreateWithFlags(my_stream, cudaStreamNonBlocking)
  print*, istat

  allocate(a(1024))
  do i = 1, 1024
    a(i) = 0
  end do

  call acc_set_cuda_stream(1, my_stream)


  ! NO cudaGraph version
  do n = 1,1000
    !$acc parallel loop copy(a(1024)) async(1) 
    do i = 1, 1024
      a(i) = a(i) + 1
    end do
  end do
  istat = cudaStreamSynchronize(my_stream)
  print*, "a:", a(1)


  ! Capture only, NO kerenl execution
  istat = cudaStreamBeginCapture(my_stream, 0)
  print*, istat

  do n = 1,1000
    !$acc parallel loop copy(a(1024)) async(1) 
    do i = 1, 1024
      a(i) = a(i) + 1
    end do
  end do
  ! prove NO kernel execution
  print*, "a:", a(1)

  istat = cudaStreamEndCapture(my_stream, graph)
  print*, istat


  ! execute cudaGraph
  buffer_len = 0
  istat = cudaGraphInstantiate(graph_exec, graph, error_node, buffer, buffer_len)
  print*, istat

  ! 1st time
  istat = cudaGraphLaunch(graph_exec, my_stream)
  print*, istat

  istat = cudaStreamSynchronize(my_stream)
  print*, "a:", a(1)

  ! 2nd time
  istat = cudaGraphLaunch(graph_exec, my_stream)
  print*, istat

  istat = cudaStreamSynchronize(my_stream)
  print*, "a:", a(1)

end program
