program main
    use mpi
    implicit none
    integer rank, size, tag, count, ierr
    integer src, dest
    integer status(mpi_status_size)
    real data(3)

    call mpi_init(ierr)
    call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)
    call mpi_comm_size(MPI_COMM_WORLD, size, ierr)
    print *, 'process ', rank, ' of ', size, ' is alive'

    data = 0
    dest = size - 1
    src = 0
    count = 3
    tag = 0

    if (rank .eq. dest) then
        print *, 'before mpi send-recv:', data
    endif
    call mpi_barrier(MPI_COMM_WORLD, ierr)

    if (rank .eq. src) then
        data = 123
        print*, 'send \"123\" to destination process'
        call mpi_send(data, count, MPI_REAL, dest, tag, MPI_COMM_WORLD, ierr)
    else if (rank .eq. dest) then
        call mpi_recv(data, count, MPI_REAL, src, tag, MPI_COMM_WORLD, status, ierr)
    endif
  
    call mpi_barrier(MPI_COMM_WORLD, ierr)

    if (rank .eq. dest) then
        print *, 'after mpi send-recv:', data
    endif

    call mpi_finalize(ierr)
end program main

