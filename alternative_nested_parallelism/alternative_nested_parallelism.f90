program main
    implicit none
    integer :: i, j, m, n, max_n
    integer, allocatable :: task(:)
    integer, allocatable :: buff(:, :)

    m = 10
    max_n = 6
    allocate(task(m))
    do i = 1, m
        task(i) = mod(i, max_n)
    end do

    allocate(buff(max_n, m))
    buff = 0

    !$acc parallel loop gang(dim:2) copy(buff)
    do i = 1, m
        n = task(i)
        !$acc loop
        do j = 1, n
            buff(j, i) = 1
        end do
    end do

    print*, buff
    deallocate(task, buff)
end program main
