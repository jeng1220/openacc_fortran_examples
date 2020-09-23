subroutine foo(sub_data, n)
    !$acc routine vector
    implicit none

    integer i, n
    integer sub_data(n)

    print*, 'foo(device routine) is invoked by GPU'

    !$acc loop
    do i = 1, n
        sub_data(i) = sub_data(i) + 1 
    end do
end subroutine

program main
    !$acc routine(foo) vector
    implicit none

    integer y, w, h
    integer, allocatable :: all_data(:, :)

    w = 6
    h = 3
    allocate(all_data(w, h))
    all_data = 0

    print*, 'only launch 1 GPU kernel here:'

    !$acc parallel loop gang copy(all_data)
    do y = 1, h
        all_data(:, y) = y
        call foo(all_data(:, y), w)
    end do

    print*, all_data
    deallocate(all_data)

end program main
