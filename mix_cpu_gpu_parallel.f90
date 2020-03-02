
program main
    implicit none
    integer i, j, n, m, size
    integer, allocatable, dimension(:) :: task
    integer, allocatable, dimension(:) :: data

    n = 10
    size = 1000
    allocate(task(n))
    do i=1, n
        task(i) = i * size
    end do
    print*, task
    
    !$omp parallel do private(i, m, data) schedule(dynamic)
    do j=1, n
        m = task(j)
        allocate(data(m))

        !$acc parallel loop async(j)
        do i=1, m
            data(i) = j
        end do

        deallocate(data)
    end do
    !$omp end parallel do

    call acc_async_wait_all()

    deallocate(task)
    
end program main
