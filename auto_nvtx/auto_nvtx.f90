subroutine other(n)
    implicit none
    integer :: n

    call sleep(1)
end subroutine other

subroutine bar(n)
    implicit none
    integer :: i, n

    call other(n)
end subroutine bar

subroutine foo(n)
    implicit none
    integer :: i, n

    call bar(n)
end subroutine foo

program main
    implicit none
    integer :: i, n

    n = 3
    do i = 1, n
        call foo(n)
    end do    
end program main
