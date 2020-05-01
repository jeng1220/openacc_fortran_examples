subroutine other(n)
    implicit none
    integer :: i, n
    do i=1, n*100
    end do
end subroutine other

subroutine bar(n)
    implicit none
    integer :: i, n
    do i=1, n
        call other(n)
    end do
end subroutine bar

subroutine foo(n)
    implicit none
    integer :: i, n
    real :: start, finish
    call cpu_time(start)
    do i=1, n
        call bar(n)
    end do
    call cpu_time(finish)
    print*, 'Time =', (finish - start)*1000, 'ms.'
end subroutine foo

program main
    implicit none
    integer :: i, n
    n = 300
    do i=1, n
        !print*, i
        call foo(n)
    end do    
end program main
