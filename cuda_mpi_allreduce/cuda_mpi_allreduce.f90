program main
    use mpi
    implicit none
    integer mpi_rank, mpi_size, ierr, n
    integer, allocatable :: sendbuf(:)
    integer, allocatable :: recvbuf(:)

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, mpi_rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, mpi_size, ierr)
    print *, 'process ', mpi_rank, ' of ', mpi_size, ' is alive'

    n = 100
    allocate(sendbuf(n))
    allocate(recvbuf(n))

    !$acc enter data create(sendbuf, recvbuf)

    !$acc kernels
    sendbuf = mpi_rank
    recvbuf = 0
    !$acc end kernels

    !$acc host_data use_device(sendbuf, recvbuf)
    call MPI_Allreduce(sendbuf, recvbuf, n, MPI_INT, MPI_SUM, MPI_COMM_WORLD, ierr)
    !$acc end host_data

    !$acc exit data copyout(recvbuf) delete(sendbuf)

    if (mpi_rank .eq. 0) then
        print *, 'after MPI Allreduce:\n', recvbuf
    end if

    call MPI_Finalize(ierr)
    deallocate(sendbuf, recvbuf)
end program main

