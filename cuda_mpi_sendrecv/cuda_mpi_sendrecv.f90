program main
    use cudafor
    use mpi
    implicit none
    integer mpi_rank, mpi_size, tag, n, ierr, i
    integer, allocatable :: sendbuf(:), recvbuf(:)
    integer dst, src, p2p
    real start, finish

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, mpi_rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, mpi_size, ierr)
    print *, 'process ', mpi_rank, ' of ', mpi_size, ' is alive'

    ierr = cudaSetDevice(mpi_rank)
    ierr = cudaGetDeviceCount(n)
    ! enable GPU Direct P2P
    do i = 0, (n - 1)
        ierr = cudaDeviceCanAccessPeer(p2p, mpi_rank, i)
        if (p2p .eq. 1) then
            ierr = cudaDeviceEnablePeerAccess(i, 0)
        end if
    end do

    n = 1000000
    allocate(sendbuf(n))
    allocate(recvbuf(n))

    !$acc enter data create(sendbuf, recvbuf)
    !$acc kernels present(sendbuf, recvbuf)
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
    call cpu_time(start)
    call MPI_Sendrecv(sendbuf, n, MPI_INTEGER, &
                      dst, tag, &
                      recvbuf, n, MPI_INTEGER, &
                      src, tag, &
                      MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
    call cpu_time(finish)
    if (mpi_rank .eq. 0) then
        print '("CUDA-Aware MPI Sendrecv 1st time = ",f6.3," seconds.")', (finish - start)
    end if

    call cpu_time(start)
    call MPI_Sendrecv(sendbuf, n, MPI_INTEGER, &
                      dst, tag, &
                      recvbuf, n, MPI_INTEGER, &
                      src, tag, &
                      MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
    call cpu_time(finish)
    if (mpi_rank .eq. 0) then
        print '("CUDA-Aware MPI Sendrecv 2nd time = ",f6.3," seconds.")', (finish - start)
    end if
    !$acc end host_data
    !$acc exit data copyout(recvbuf) delete(sendbuf)

    if (mpi_rank .eq. mpi_size - 1) then
       print *, 'after MPI Sendrecv:\n', recvbuf(1)
    endif

    deallocate(sendbuf, recvbuf)
    call MPI_Finalize(ierr)
end program main
