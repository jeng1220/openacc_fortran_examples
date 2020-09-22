program main
    implicit none
    integer :: i, j, m, n, max_n
    integer, allocatable :: task(:)
    integer, allocatable :: histogram(:)
    double precision rand

    n = 100
    m = 6
    allocate(task(n))
    do i = 1, n
        task(i) = (rand(0) * m)
    end do

    allocate(histogram(m))
    histogram = 0

    !$acc parallel loop copyin(task) copy(histogram) private(j)
    do i = 1, n
        j = task(i)
        j = j + 1
        !$acc atomic update
        histogram(j) = histogram(j) + 1
        !$acc end atomic
    end do

    print*, 'task:\n', task
    print*, 'histogram:\n'
    do i = 1, m
        print*, (i - 1), ':', histogram(i)
    end do
    deallocate(task, histogram)
end program main
