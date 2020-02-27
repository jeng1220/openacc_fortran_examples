subroutine foo(my_data, w, h)
    !$acc routine vector
    use bar
    implicit none
    integer x, w, h
    integer, contiguous, dimension(w, h), intent(inout) :: my_data
    !$acc loop
    do x=1, w
        my_data(x, 1) = my_data(x, 1) + 1 + var
    end do
end subroutine

program main
    !$acc routine(foo) vector
    use bar
    implicit none
    integer x, y, w, h
    integer, allocatable, contiguous, dimension(:,:) :: pdata

    w = 1000
    h = 1000
    allocate(pdata(w, h))
    pdata(:,:) = 0

    var = 77

    !$acc parallel loop gang
    do y=1, h
        pdata(1:w, y) = y
        call foo(pdata(1:w, y), w, 1)
    end do

    print*, pdata
    deallocate(pdata)

end program main
