subroutine acc_loop_2d()
    implicit none
    integer i, j, n
    real, allocatable, contiguous, dimension(:,:) :: data

    n = 10000
    allocate(data(n, n))

    if (is_contiguous (data)) then
      write (*,*) 'data is contiguous'
    else
      write (*,*) 'data is not contiguous'
    end if

    !$acc parallel loop copy(data(n, n)) 
    do j=1, n
      !$acc loop independent 
      do i=1, n
        data(i, j) = data(i, j) + 1
      end do
    end do

    !$acc parallel loop copy(data(n, n)) 
    do i=1, n
      !$acc loop independent 
      do j=1, n
        data(i, j) = data(i, j) + 1
      end do
    end do

    print*, data(1, 1)
    deallocate(data)
end subroutine

subroutine acc_loop_3d()
    implicit none
    integer i, j, k
    integer n
    real, allocatable, contiguous, dimension(:,:,:) :: data

    n = 1000
    allocate(data(n, n, n))

    if (is_contiguous (data)) then
      write (*,*) 'data is contiguous'
    else
      write (*,*) 'data is not contiguous'
    end if

    !$acc parallel loop copy(data(n, n, n)) 
    do k=1, n
      !$acc loop independent worker 
      do j=1, n
        !$acc loop independent vector
        do i=1, n
          data(i, j, k) = data(i, j, k) + 1
        end do
      end do
    end do

    !$acc parallel loop copy(data(n, n, n)) 
    do i=1, n
      !$acc loop independent worker
      do j=1, n
        !$acc loop independent vector
        do k=1, n
          data(i, j, k) = data(i, j, k) + 1
        end do
      end do
    end do

    !$acc parallel loop copy(data(n, n, n)) 
    do i=1, n
      !$acc loop independent worker
      do k=1, n
        !$acc loop independent vector
        do j=1, n
          data(i, j, k) = data(i, j, k) + 1
        end do
      end do
    end do

    !$acc parallel loop copy(data(n, n, n)) 
    do j=1, n
      !$acc loop independent worker
      do k=1, n
        !$acc loop independent vector
        do i=1, n
          data(i, j, k) = data(i, j, k) + 1
        end do
      end do
    end do

    print*, data(1, 1, 1)
    deallocate(data)
end subroutine

program main
    implicit none
    call acc_loop_2d
    call acc_loop_3d
end program main

