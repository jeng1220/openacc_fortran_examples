 module cuda_graph
  use iso_c_binding

  ! enums

  enum, bind(C) ! cudaStreamCaptureMode
     enumerator :: cudaStreamCaptureModeGlobal=0
     enumerator :: cudaStreamCaptureModeThreadLocal=1
     enumerator :: cudaStreamCaptureModeRelaxed=2
  end enum

  ! types

  type cudaGraph
    type(c_ptr) :: graph
  end type cudaGraph

  type cudaGraphExec
    type(c_ptr) :: graph_exec
  end type cudaGraphExec

  type cudaGraphNode
    type(c_ptr) :: graph_node
  end type cudaGraphNode

  ! ---------
  ! functions
  ! ---------

  !----------------------------------
  ! Additional cudaStream functions
  !----------------------------------
  interface
     integer(c_int) function cudaStreamBeginCapture(stream, mode) &
          bind(C,name='cudaStreamBeginCapture')
       use cudafor
       integer(cuda_stream_kind), value ::  stream
       integer(c_int), value :: mode
     end function cudaStreamBeginCapture
  end interface

  interface
     integer(c_int) function cudaStreamEndCapture(stream, pGraph) &
          bind(C,name='cudaStreamEndCapture')
       use cudafor
       import cudaGraph
       integer(cuda_stream_kind), value ::  stream
       type(cudaGraph) :: pGraph
     end function cudaStreamEndCapture
  end interface


  !----------------------------------
  ! new cudaGraph functions
  !----------------------------------
  interface
     integer(c_int) function cudaGraphCreate(pGraph, flags) &
          bind(C,name='cudaGraphCreate')
       import cudaGraph
       type(cudaGraph) :: graph
       integer :: flags
     end function cudaGraphCreate
  end interface

  interface
     integer(c_int) function cudaGraphInstantiate(pGraphExec, graph, pErrorNode, pLogBuffer, bufferSize) &
          bind(C,name='cudaGraphInstantiate')
       use cudafor
       import cudaGraph
       import cudaGraphExec
       import cudaGraphNode
       type(cudaGraphExec) :: pGraphExec
       type(cudaGraph), value :: graph
       type(cudaGraphNode) :: pErrorNode
       character(kind=C_CHAR, len=*) :: pLogBuffer
       integer(c_size_t), value :: bufferSize
     end function cudaGraphInstantiate
  end interface

  interface
     integer(c_int) function cudaGraphLaunch(graphExec, stream) &
          bind(C,name='cudaGraphLaunch')
       use cudafor
       import cudaGraphExec
       type(cudaGraphExec), value :: graphExec
       integer(cuda_stream_kind), value ::  stream
     end function cudaGraphLaunch
  end interface

end module
