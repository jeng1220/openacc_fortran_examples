program main
    use cudafor
    use mpi
    implicit none
    integer mpi_rank, mpi_size, ierr, n, p2p, i
    integer, allocatable :: buf(:)

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, mpi_rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, mpi_size, ierr)
    print *, 'process ', mpi_rank, ' of ', mpi_size, ' is alive'

    n = 10000000
    allocate(buf(n))

    if (mpi_rank .eq. 0) then
        !$acc kernels
        buf = mpi_size
        !$acc end kernels
    end if

    call MPI_Bcast(buf, n, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr) 

    if (buf(1) .ne. mpi_size) then
       print*, 'buf is', buf(1), ', but it should be', mpi_size
    end if

    if (mpi_rank .eq. 0) then
        print*, 'PASSED'
    end if

    call MPI_Finalize(ierr)
    deallocate(buf)
end program main

