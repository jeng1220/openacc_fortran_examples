subroutine foo(sub_data, w, h)
    !$acc routine vector
    implicit none

    integer x, w, h
    integer, contiguous, dimension(w, h), intent(inout) :: sub_data

    print*, 'foo(device routine) is invoked by GPU'

    !$acc loop
    do x = 1, w
        sub_data(x, 1) = sub_data(x, 1) + 1 
    end do
end subroutine

program main
    !$acc routine(foo) vector
    implicit none

    integer x, y, w, h
    integer, allocatable, contiguous, dimension(:, :) :: all_data

    w = 6
    h = 3
    allocate(all_data(w, h))
    all_data(:, :) = 0

    print*, 'only launch 1 GPU kernel here:'

    !$acc parallel loop gang copy(all_data)
    do y = 1, h
        all_data(1:w, y) = y
        call foo(all_data(1:w, y), w, 1)
    end do


    print*, all_data
    deallocate(all_data)

end program main
