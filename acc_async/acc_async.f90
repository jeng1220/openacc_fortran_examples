subroutine with_async(x, n, id)
    implicit none
    integer n, id, i
    real x(n)

    !$acc kernels copy(x) async(id)
    do i = 1, 5000
      x = x * 2 + 1
    end do
    !$acc end kernels
end subroutine

subroutine without_async(x, n)
    implicit none
    integer n, i
    real x(n)

    !$acc kernels copy(x) 
    do i = 1, 5000
      x = x * 2 + 1
    end do
    !$acc end kernels
end subroutine

program main
    implicit none
    integer i, n, m
    real, allocatable :: buf(:, :)
    real start, finish

    m = 10
    n = 1000000
    allocate(buf(n, m))

    !$acc kernels copy(buf)
    buf = 0
    !$acc end kernels

    call cpu_time(start)
    do i = 1, m
        call without_async(buf(:, i), n)
    end do
    call cpu_time(finish)
    print '("Without OpenACC async time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    do i = 1, m
        call with_async(buf(:, i), n, mod(i, 2) + 1)
    end do
    !$acc wait(1, 2)
    call cpu_time(finish)
    print '("With OpenACC async time = ",f6.3," seconds.")', (finish - start)
    deallocate(buf)
end program main
