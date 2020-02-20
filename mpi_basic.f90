program main
    use mpi
    implicit none
    integer rank, size, tag, count, ierr
    integer src, dest
    integer status(mpi_status_size)
    double precision data(10)

    call mpi_init(ierr)
    call mpi_comm_rank(mpi_comm_world, rank, ierr)
    call mpi_comm_size(mpi_comm_world, size, ierr)
    print *, 'process ', rank, ' of ', size, ' is alive'
    call mpi_barrier(mpi_comm_world, ierr)

    dest = size - 1
    src = 0
    count = 10
    tag = 0

    if (rank .eq. dest) then
        print *, 'before mpi send-recv:', data
    endif

    if (rank .eq. src) then
        data = 777
        call mpi_send(data, count, mpi_double_precision, dest, tag, mpi_comm_world, ierr)
    else if (rank .eq. dest) then
        call mpi_recv(data, count, mpi_double_precision, src, tag, mpi_comm_world, status, ierr)
    endif
  
    call mpi_barrier(mpi_comm_world, ierr)

    if (rank .eq. dest) then
        print *, 'after mpi send-recv:', data
    endif

    call mpi_finalize(ierr)
end program main

