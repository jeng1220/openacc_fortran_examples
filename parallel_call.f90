subroutine foo(my_data, w, h)
    !$acc routine vector
    implicit none
    integer x, w, h
    integer, contiguous, dimension(w, h), intent(inout) :: my_data

    !$acc loop
    do x=1, w
        my_data(x, 1) = my_data(x, 1) + 1
    end do
end subroutine

program main
    !$acc routine(foo) vector
    implicit none
    integer x, y, w, h
    integer, allocatable, contiguous, dimension(:,:) :: pdata
    integer, allocatable, contiguous, dimension(:,:) :: sdata

    w = 1000
    h = 1000
    allocate(pdata(w, h))
    pdata(:,:) = 0

    allocate(sdata(w, h))
    sdata(:,:) = 0

    !$acc parallel loop gang copy(pdata)
    do y=1, h
        pdata(1:w, y) = y
        call foo(pdata(1:w, y), w, 1)
    end do

    do y=1, h
        sdata(1:w, y) = y
        call foo(sdata(1:w, y), w, 1)
    end do

    do y=1, h
        do x=1, w
            if (pdata(x, y) /= sdata(x, y)) then
                print*, 'FAILURE'
                stop
            endif
        end do
    end do
    print*, 'PASSED'

    deallocate(pdata)
    deallocate(sdata)
end program main
