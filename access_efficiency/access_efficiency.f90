subroutine acc_loop_2d()
    implicit none
    integer i, j, n
    real, allocatable, contiguous, dimension(:,:) :: data
    real start, finish

    n = 10000
    allocate(data(n, n))
    !$acc enter data create(data(n, n))

    print*, "2D access:"

    call cpu_time(start)
    !$acc parallel loop present(data(n, n))
    do j=1, n
      !$acc loop independent 
      do i=1, n
        data(i, j) = data(i, j) + 1
      end do
    end do
    call cpu_time(finish)
    print '("I, J order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(data(n, n)) 
    do i=1, n
      !$acc loop independent 
      do j=1, n
        data(i, j) = data(i, j) + 1
      end do
    end do
    call cpu_time(finish)
    print '("J, I order time = ",f6.3," seconds.")', (finish - start)

    !$acc exit data delete(data)
    deallocate(data)
end subroutine

subroutine acc_loop_3d()
    implicit none
    integer i, j, k
    integer n
    real, allocatable, contiguous, dimension(:,:,:) :: data
    real start, finish
    n = 1000
    allocate(data(n, n, n))
    !$acc enter data create(data(n, n, n))

    print*, "3D access:"

    call cpu_time(start)
    !$acc parallel loop present(data(n, n, n)) 
    do k=1, n
      !$acc loop independent worker 
      do j=1, n
        !$acc loop independent vector
        do i=1, n
          data(i, j, k) = data(i, j, k) + 1
        end do
      end do
    end do
    call cpu_time(finish)
    print '("I, J, K order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(data(n, n, n)) 
    do j=1, n
      !$acc loop independent worker
      do k=1, n
        !$acc loop independent vector
        do i=1, n
          data(i, j, k) = data(i, j, k) + 1
        end do
      end do
    end do
    call cpu_time(finish)
    print '("I, K, J order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(data(n, n, n)) 
    do i=1, n
      !$acc loop independent worker
      do k=1, n
        !$acc loop independent vector
        do j=1, n
          data(i, j, k) = data(i, j, k) + 1
        end do
      end do
    end do
    call cpu_time(finish)
    print '("J, K, I order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(data(n, n, n)) 
    do k=1, n
      !$acc loop independent worker
      do i=1, n
        !$acc loop independent vector
        do j=1, n
          data(i, j, k) = data(i, j, k) + 1
        end do
      end do
    end do
    call cpu_time(finish)
    print '("J, I, K order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(data(n, n, n)) 
    do i=1, n
      !$acc loop independent worker
      do j=1, n
        !$acc loop independent vector
        do k=1, n
          data(i, j, k) = data(i, j, k) + 1
        end do
      end do
    end do
    call cpu_time(finish)
    print '("K, J, I order time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc parallel loop present(data(n, n, n)) 
    do j=1, n
      !$acc loop independent worker
      do i=1, n
        !$acc loop independent vector
        do k=1, n
          data(i, j, k) = data(i, j, k) + 1
        end do
      end do
    end do
    call cpu_time(finish)
    print '("K, I, J order time = ",f6.3," seconds.")', (finish - start)

    !$acc exit data delete(data)

    deallocate(data)
end subroutine

program main
    implicit none
    call acc_loop_2d
    call acc_loop_3d
end program main

