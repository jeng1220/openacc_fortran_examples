program main
    use mpi
    use cudafor
    use nccl
    implicit none
    integer i, j, mpi_rank, mpi_size, n, ierr
    integer, allocatable :: sendbuf(:,:), mpi_recvbuf(:,:), nccl_recvbuf(:,:)
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
    allocate(sendbuf(n, mpi_size))
    allocate(mpi_recvbuf(n, mpi_size))
    allocate(nccl_recvbuf(n, mpi_size))

    !$acc enter data create(sendbuf, mpi_recvbuf, nccl_recvbuf)

    !$acc kernels
    do j = 1, mpi_size
    do i = 1, n
        sendbuf(i, j) = mpi_rank + j * n + i
    end do
    end do
    mpi_recvbuf = 0
    nccl_recvbuf = 0
    !$acc end kernels

    call cpu_time(start)
    !$acc host_data use_device(sendbuf, mpi_recvbuf)
    call MPI_Alltoall(sendbuf, n, MPI_INTEGER, &
                      mpi_recvbuf, n, MPI_INTEGER, &
                      MPI_COMM_WORLD, ierr)
    !$acc end host_data
    call cpu_time(finish)
    if (mpi_rank .eq. 0) then
        print '("MPI Alltoall time = ",f6.3," seconds.")', (finish - start)
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
        nccl_stat = ncclSend(sendbuf(1, i+1), n, ncclInt, i, nccl_comm, cuda_stream)
        nccl_stat = ncclRecv(nccl_recvbuf(1, i+1), n, ncclInt, i, nccl_comm, cuda_stream)
    end do
    !$acc end host_data
    nccl_stat = ncclGroupEnd()
    cuda_stat = cudaStreamSynchronize(cuda_stream)
    call cpu_time(finish)
    if (mpi_rank .eq. 0) then
        print '("NCCL Alltoall time = ",f6.3," seconds.")', (finish - start)
    end if

    !$acc exit data delete(sendbuf) copyout(mpi_recvbuf, nccl_recvbuf)
    do j = 1, mpi_size
    do i = 1, n
        if (mpi_recvbuf(i, j) .ne. nccl_recvbuf(i, j)) then
            print*, 'ERROR, NCCL Alltoall is NOT equal to MPI Alltoall'
            call exit
        end if
    end do
    end do

    if (mpi_rank .eq. 0) then
        print*, 'PASSED, NCCL Alltoall is equal to MPI Alltoall'
    end if

    deallocate(sendbuf, mpi_recvbuf, nccl_recvbuf)
    call MPI_Finalize(ierr)
end program main

