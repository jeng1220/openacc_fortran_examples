module bar
    implicit none
    public
    integer, allocatable :: global_var
    !$acc declare present(global_var)
contains
end module

subroutine foo(sub_data, n)
    !$acc routine vector
    use bar
    implicit none

    integer i, n
    integer sub_data(n)
    print*, 'GPU thread reads a variable from module \"bar\"'
    !$acc loop
    do i = 1, n
        sub_data(i) = sub_data(i) + 1 + global_var
    end do
end subroutine

program main
    !$acc routine(foo) vector
    use bar
    implicit none

    integer y, w, h
    integer, allocatable :: all_data(:, :)

    w = 6
    h = 3
    allocate(all_data(w, h))
    all_data = 0

    global_var = 123

    !$acc parallel loop gang
    do y = 1, h
        all_data(:, y) = y
        call foo(all_data(:, y), w)
    end do

    print*, all_data
    deallocate(all_data)
end program main
