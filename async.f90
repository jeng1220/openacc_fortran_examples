subroutine foo(out, w)
    implicit none
    integer i, w
    integer out
    integer my_data(w)

    !$acc kernels async
    my_data(1:w) = 1
    !$acc end kernels

    !$acc parallel loop reduction(+:out) async
    do i=1, w
        out = out + my_data(i)
    end do
end subroutine

subroutine bar(w)
    implicit none
    integer w
    integer my_data(w)

    !$acc kernels async
    my_data(1:w) = 1
    !$acc end kernels
end subroutine

program main
    implicit none
    integer i, j, size
    integer results(10)

    results(1:10) = 0

    do j=1, 10
        size = 1000
        do i=1, 10
            call acc_set_default_async(mod(i, 4))
            size = size * 2
            call foo(results(i), size)
        end do
    end do
    call acc_async_wait_all()

    print*, results

    do j=1, 10
        size = 1000
        do i=1, 10
            call acc_set_default_async(mod(i, 4))
            size = size * 2
            call bar(size)
        end do
    end do
    call acc_async_wait_all()

end program main
