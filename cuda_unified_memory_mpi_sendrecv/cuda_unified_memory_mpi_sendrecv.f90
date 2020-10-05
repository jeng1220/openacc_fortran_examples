program main
    use mpi
    implicit none
    integer mpi_rank, mpi_size, tag, n, ierr
    integer, allocatable :: sendbuf(:), recvbuf(:)
    integer status(MPI_STATUS_SIZE)
    integer dst, src

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, mpi_rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, mpi_size, ierr)
    print *, 'process ', mpi_rank, ' of ', mpi_size, ' is alive'

    n = 100
    allocate(sendbuf(n))
    allocate(recvbuf(n))
    !$acc kernels
    recvbuf = 0
    sendbuf = mpi_rank + 1
    !$acc end kernels

    tag = 0
    src = mod(mpi_rank + 1, mpi_size)
    dst = mpi_rank - 1
    if (dst < 0) then
        dst = mpi_size - 1
    end if
    if (mpi_rank .eq. 0) then
        print*, 'send \"1\" to destination process'
    end if

    !$acc host_data use_device(sendbuf, recvbuf)
    call MPI_Sendrecv(sendbuf, n, MPI_INTEGER, &
                      dst, tag, &
                      recvbuf, n, MPI_INTEGER, &
                      src, tag, &
                      MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
    !$acc end host_data

    if (mpi_rank .eq. mpi_size - 1) then
       print *, 'after MPI Sendrecv:\n', recvbuf
    endif

    deallocate(sendbuf, recvbuf)
    call MPI_Finalize(ierr)
end program main

