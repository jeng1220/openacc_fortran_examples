program main
    implicit none
    integer i, j, n, m
    integer, allocatable, dimension(:) :: task
    integer, allocatable, dimension(:) :: data

    n = 10
    allocate(task(n))
    do i=1, n
        task(i) = i * 1000
    end do
    print*, 'parallel 10 tasks, each task has 1 GPU kernel'
    
    !$omp parallel do private(i, m, data) schedule(dynamic)
    do j=1, n
        m = task(j)
        allocate(data(m))

        !$acc parallel loop copy(data) async(j)
        do i=1, m
            data(i) = j
        end do
        !$acc wait(j)

        deallocate(data)
    end do
    !$omp end parallel do

    deallocate(task)
    
end program main
