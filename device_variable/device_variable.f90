module bar
    implicit none
    public
    integer, allocatable :: global_var
    !$acc declare present(global_var)
contains
end module

subroutine foo(sub_data, w, h)
    !$acc routine vector
    use bar
    implicit none

    integer x, w, h
    integer, contiguous, dimension(w, h), intent(inout) :: sub_data
    !$acc loop
    do x = 1, w
        sub_data(x, 1) = sub_data(x, 1) + 1 + global_var
    end do
end subroutine

program main
    !$acc routine(foo) vector
    use bar
    implicit none

    integer x, y, w, h
    integer, allocatable, contiguous, dimension(:,:) :: all_data

    w = 6
    h = 3
    allocate(all_data(w, h))
    all_data(:, :) = 0

    global_var = 123

    !$acc parallel loop gang
    do y = 1, h
        all_data(1:w, y) = y
        call foo(all_data(1:w, y), w, 1)
    end do

    print*, all_data
    deallocate(all_data)

end program main
