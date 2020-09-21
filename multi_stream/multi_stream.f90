subroutine foo(x, n, stream_id)
    implicit none
    integer i, n, stream_id
    real x(n)

    !$acc kernels loop present(x(n)) gang(10) async(stream_id)
    do i = 1, n
        x(i) = (x(i) + 1)
    end do
    !$acc end kernels
end subroutine

subroutine bar(x, n, stream_id)
    implicit none
    integer i, n, stream_id
    real x(n)

    !$acc kernels loop present(x(n)) gang(10) async(stream_id)
    do i = 1, n
        x(i) = (x(i) * 2)
    end do
    !$acc end kernels
end subroutine

program main
    implicit none
    integer i, n
    real, allocatable :: a0(:)
    real, allocatable :: a1(:)
    real, allocatable :: a2(:)
    real start, finish

    n = 1000000
    allocate(a0(n))
    allocate(a1(n))
    allocate(a2(n))

    a0 = 0
    a1 = 0
    a2 = 0

    ! warm up
    !$acc enter data copyin(a0)
    call foo(a0, n, 0)
    !$acc wait(0)
    !$acc exit data copyout(a0)

    call cpu_time(start)
    !$acc enter data copyin(a0, a1, a2) async(0)
    do i = 1, 100
        call foo(a0, n, 0)
        call bar(a0, n, 0)
        call foo(a1, n, 0)
        call bar(a1, n, 0)
        call foo(a2, n, 0)
        call bar(a2, n, 0)
    end do
    !$acc exit data copyout(a0, a1, a2) async(0)
    !$acc wait(0)
    call cpu_time(finish)
    print '("Without Multi-Stream time = ",f6.3," seconds.")', (finish - start)

    call cpu_time(start)
    !$acc enter data copyin(a0) async(1)
    !$acc enter data copyin(a1) async(2)
    !$acc enter data copyin(a2) async(3)
    do i = 1, 100
        call foo(a0, n, 1)
        call bar(a0, n, 1)
        call foo(a1, n, 2)
        call bar(a1, n, 2)
        call foo(a2, n, 3)
        call bar(a2, n, 3)
    end do
    !$acc exit data copyout(a0) async(1)
    !$acc exit data copyout(a1) async(2)
    !$acc exit data copyout(a2) async(3)
    !$acc wait(0, 1, 2)
    call cpu_time(finish)
    print '("With Multi-Stream time = ",f6.3," seconds.")', (finish - start)
end program main
