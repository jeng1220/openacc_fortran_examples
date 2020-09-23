subroutine acc_loop_2d()
    implicit none
    integer i, j, n
    real, allocatable :: buf(:, :)
    real start, finish

    n = 10000
    allocate(buf(n, n))
    !$acc enter data create(buf)

    print*, "2D access:"

    call cpu_time(start)
    !$acc parallel loop present(buf) collapse(2)
    do j=1, n
    do i=1, n
        buf(i, j) = buf(i, j) + 1
    end do
    end do
    call cpu_time(finish)
    print '("I, J order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(buf) collapse(2)
    do i=1, n
    do j=1, n
        buf(i, j) = buf(i, j) + 1
    end do
    end do
    call cpu_time(finish)
    print '("J, I order time = ",f6.3," seconds.")', (finish - start)

    !$acc exit data delete(buf)
    deallocate(buf)
end subroutine

subroutine acc_loop_3d()
    implicit none
    integer i, j, k, n
    real, allocatable :: buf(:, :, :)
    real start, finish
    n = 1000
    allocate(buf(n, n, n))
    !$acc enter data create(buf)

    print*, "3D access:"

    call cpu_time(start)
    !$acc parallel loop present(buf) collapse(3)
    do k=1, n
    do j=1, n
    do i=1, n
        buf(i, j, k) = buf(i, j, k) + 1
    end do
    end do
    end do
    call cpu_time(finish)
    print '("I, J, K order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(buf) collapse(3)
    do j=1, n
    do k=1, n
    do i=1, n
        buf(i, j, k) = buf(i, j, k) + 1
    end do
    end do
    end do
    call cpu_time(finish)
    print '("I, K, J order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(buf) collapse(3)
    do i=1, n
    do k=1, n
    do j=1, n
          buf(i, j, k) = buf(i, j, k) + 1
    end do
    end do
    end do
    call cpu_time(finish)
    print '("J, K, I order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(buf) collapse(3)
    do k=1, n
    do i=1, n
    do j=1, n
        buf(i, j, k) = buf(i, j, k) + 1
    end do
    end do
    end do
    call cpu_time(finish)
    print '("J, I, K order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(buf) collapse(3)
    do i=1, n
    do j=1, n
    do k=1, n
        buf(i, j, k) = buf(i, j, k) + 1
    end do
    end do
    end do
    call cpu_time(finish)
    print '("K, J, I order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(buf) collapse(3)
    do j=1, n
    do i=1, n
    do k=1, n
        buf(i, j, k) = buf(i, j, k) + 1
    end do
    end do
    end do
    call cpu_time(finish)
    print '("K, I, J order time = ",f6.3," seconds.")', (finish - start)

    !$acc exit data delete(buf)

    deallocate(buf)
end subroutine

program main
    implicit none
    call acc_loop_2d
    call acc_loop_3d
end program main

