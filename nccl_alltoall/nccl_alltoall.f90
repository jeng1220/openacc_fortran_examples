subroutine print_data(x, n, rank, size)
    use mpi
    implicit none
    integer :: i, n, rank, size, ierr
    integer :: x(n)
 
    do i = 0, (size - 1)
        call mpi_barrier(MPI_COMM_WORLD, ierr)
        if (i .eq. rank) then
            print*, "rank:\n", rank
            print*, "data:\n", x
            call flush(6)
        end if
        call mpi_barrier(MPI_COMM_WORLD, ierr)
    end do   
end subroutine

program main
    use mpi
    use cudafor
    use nccl
    implicit none
    integer rank, size, tag, count, total, ierr
    integer src, dest
    integer i
    integer status(mpi_status_size)
    integer, allocatable :: sendbuf(:)
    integer, allocatable :: recvbuf(:)
    ! NCCL data:
    type(ncclResult) :: nccl_stat
    type(ncclUniqueId) :: nccl_uid
    type(ncclComm) :: nccl_comm
    integer cuda_stat, num_gpu
    integer(kind=cuda_stream_kind) :: cuda_stream

    call mpi_init(ierr)
    call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)
    call mpi_comm_size(MPI_COMM_WORLD, size, ierr)
    print *, 'process ', rank, ' of ', size, ' is alive'
    ! must be called at first
    cuda_stat = cudaSetDevice(rank)

    count = 4
    total = count * size
    allocate(sendbuf(total))
    allocate(recvbuf(total))

    do i = 1, total
        sendbuf(i) = i + rank * size
    end do
    recvbuf = 0
    call print_data(sendbuf, total, rank, size)
    call mpi_barrier(MPI_COMM_WORLD, ierr)

    if (rank .eq. 0) then
        print*, "MPI Alltoall:"
        call flush(6)
    end if

    ! MPI Alltoall: 
    call mpi_alltoall(sendbuf, count, MPI_INT, &
                      recvbuf, count, MPI_INT, &
                      MPI_COMM_WORLD, ierr)
    call mpi_barrier(MPI_COMM_WORLD, ierr)

    call print_data(recvbuf, total, rank, size)
    recvbuf = 0
    if (rank .eq. 0) then
        print*, "NCCL Alltoall:"
        call flush(6)
    end if
    call mpi_barrier(MPI_COMM_WORLD, ierr)

    ! init NCCL data
    if (rank .eq. 0) then
        nccl_stat = ncclGetUniqueId(nccl_uid)
    end if
    call mpi_bcast(nccl_uid, sizeof(ncclUniqueId), MPI_BYTE, 0, MPI_COMM_WORLD, ierr)
    call mpi_barrier(MPI_COMM_WORLD, ierr)
    nccl_stat = ncclCommInitRank(nccl_comm, size, nccl_uid, rank);
    cuda_stat = cudaStreamCreate(cuda_stream)

    nccl_stat = ncclGroupStart()
    !$acc host_data use_device(sendbuf, recvbuf) 
    do i = 0, (size - 1)
        nccl_stat = ncclSend(sendbuf(1+i*count), count, ncclInt, i, nccl_comm, cuda_stream)
        nccl_stat = ncclRecv(recvbuf(1+i*count), count, ncclInt, i, nccl_comm, cuda_stream)
    end do
    !$acc end host_data
 
    nccl_stat = ncclGroupEnd()          
    cuda_stat = cudaStreamSynchronize(cuda_stream)

    call print_data(recvbuf, total, rank, size)
    call mpi_finalize(ierr)
    deallocate(sendbuf, recvbuf)
end program main

