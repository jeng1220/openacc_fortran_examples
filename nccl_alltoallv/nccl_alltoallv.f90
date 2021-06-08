program main
    use mpi
    use cudafor
    use nccl
    implicit none
    integer i, j, mpi_rank, mpi_size, n, ierr, total, offset
    integer, allocatable :: sendbuf(:), mpi_recvbuf(:), nccl_recvbuf(:)
    integer, allocatable :: sendcnts(:), sdispls(:), recvcnts(:), rdispls(:)
    real start, finish
    ! NCCL data:
    type(ncclResult) :: nccl_stat
    type(ncclUniqueId) :: nccl_uid
    type(ncclComm) :: nccl_comm
    integer cuda_stat
    integer(kind=cuda_stream_kind) :: cuda_stream

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, mpi_rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, mpi_size, ierr)
    print *, 'process ', mpi_rank, ' of ', mpi_size, ' is alive'
    ! must be called at first
    cuda_stat = cudaSetDevice(mpi_rank)

    n = 1000000
    total = n * mpi_size
    allocate(sendbuf(total))
    allocate(mpi_recvbuf(total))
    allocate(nccl_recvbuf(total))
    allocate(sendcnts(mpi_size), sdispls(mpi_size))
    allocate(recvcnts(mpi_size), rdispls(mpi_size))

    do i = 0, (mpi_size - 1)
      sdispls(i+1) = i * n
      sendcnts(i+1) = n
      rdispls(i+1) = i * n
      recvcnts(i+1) = n
    end do

    !$acc enter data create(sendbuf, mpi_recvbuf, nccl_recvbuf)
    !$acc kernels
    do i = 1, total
      sendbuf(i) = i + 100 * mpi_rank
    end do   
    mpi_recvbuf = 0
    nccl_recvbuf = 0
    !$acc end kernels

    call cpu_time(start)
    !$acc host_data use_device(sendbuf, mpi_recvbuf)
    call MPI_Alltoallv(sendbuf, sendcnts, sdispls, MPI_INTEGER, &
                      mpi_recvbuf, recvcnts, rdispls, MPI_INTEGER, &
                      MPI_COMM_WORLD, ierr)
    !$acc end host_data
    call cpu_time(finish)
    if (mpi_rank .eq. 0) then
        print '("MPI Alltoallv time = ",f6.3," seconds.")', (finish - start)
    end if

    ! init NCCL data
    if (mpi_rank .eq. 0) then
        nccl_stat = ncclGetUniqueId(nccl_uid)
    end if
    call MPI_Bcast(nccl_uid, int(sizeof(ncclUniqueId)), MPI_BYTE, 0, MPI_COMM_WORLD, ierr)
    call MPI_Barrier(MPI_COMM_WORLD, ierr)
    nccl_stat = ncclCommInitRank(nccl_comm, mpi_size, nccl_uid, mpi_rank);
    cuda_stat = cudaStreamCreate(cuda_stream)

    ! NCCL Alltoall
    call cpu_time(start)
    nccl_stat = ncclGroupStart()
    !$acc host_data use_device(sendbuf, nccl_recvbuf) 
    do i = 0, (mpi_size - 1)
        nccl_stat = ncclSend(sendbuf( sdispls(i+1)+1 ), sendcnts(i+1), ncclInt, i, nccl_comm, cuda_stream)
        nccl_stat = ncclRecv(nccl_recvbuf( rdispls(i+1)+1 ), recvcnts(i+1), ncclInt, i, nccl_comm, cuda_stream)
    end do
    !$acc end host_data
    nccl_stat = ncclGroupEnd()
    cuda_stat = cudaStreamSynchronize(cuda_stream)
    call cpu_time(finish)
    if (mpi_rank .eq. 0) then
        print '("NCCL Alltoallv time = ",f6.3," seconds.")', (finish - start)
    end if    
    !$acc exit data delete(sendbuf) copyout(mpi_recvbuf, nccl_recvbuf)

    do i = 1, total
        if (mpi_recvbuf(i) .ne. nccl_recvbuf(i)) then
            print*, 'ERROR, NCCL Alltoallv is NOT equal to MPI Alltoallv'
            call exit
        end if
    end do

    if (mpi_rank .eq. 0) then
        print*, 'PASSED, NCCL Alltoallv is equal to MPI Alltoallv'
    end if

    deallocate(sendbuf, mpi_recvbuf, nccl_recvbuf)
    deallocate(sdispls, sendcnts, rdispls, recvcnts)
    call MPI_Finalize(ierr)
end program main

