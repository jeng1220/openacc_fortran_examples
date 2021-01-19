subroutine saxpy_iso(x, y, n, a)
  real :: a, x(n), y(n)
  integer :: n, i

  do concurrent (i = 1: n) 
    y(i) = a * x(i) + y(i)
  enddo  
end subroutine saxpy_iso

subroutine saxpy_acc(x, y, n, a)
  real :: a, x(n), y(n)
  integer :: n, i  

  !$acc parallel loop copy(x, y)
  do i = 1, n
    y(i) = a * x(i) + y(i)
  enddo  
end subroutine saxpy_acc

program main
    implicit none
    integer i, n
    real, allocatable :: x(:), y(:)
    real start, finish

    n = 1000000000
    allocate(x(n), y(n))

    !$acc kernels
    x(:) = 1
    y(:) = 2
    !$acc end kernels

    call cpu_time(start)
    call saxpy_acc(x, y, n, 0.5)
    call cpu_time(finish)
    print '("OpenACC saxpy time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    call saxpy_iso(x, y, n, 0.5)
    call cpu_time(finish)
    print '("ISO Standard saxpy time = ",f6.3," seconds.")', (finish - start)

    deallocate(x, y)
end program main
