program main
    implicit none
    integer :: n
    real, allocatable :: a(:, :, :, :)
    integer :: i, j, k, l
    real start, finish

    n = 100
    allocate(a(n, n, n, n))
    !$acc enter data create(a(n, n, n, n))

    call cpu_time(start)
    !$acc parallel present(a)
    a = 0.0
    !$acc end parallel
    call cpu_time(finish)
    print '("parallel setting 0 time = ",f6.3," seconds.")', (finish - start) 

    call cpu_time(start)   
    !$acc parallel present(a)
    a(:,:,:,:) = 0.0
    !$acc end parallel
    call cpu_time(finish)
    print '("parallel setting 1 time = ",f6.3," seconds.")', (finish - start) 

    call cpu_time(start)   
    !$acc parallel present(a)
    a(1:n,1:n,1:n,1:n) = 0.0
    !$acc end parallel
    call cpu_time(finish)
    print '("parallel setting 2 time = ",f6.3," seconds.")', (finish - start) 

    call cpu_time(start)    
    !$acc parallel loop present(a) collapse(4)
    do l = 1, n 
    do k = 1, n 
    do j = 1, n 
    do i = 1, n 
        a(i,j,k,l) = 0.0
    end do
    end do
    end do
    end do
    call cpu_time(finish)
    print '("parallel setting 3 time = ",f6.3," seconds.")', (finish - start) 

    call cpu_time(start)   
    !$acc kernels present(a)
    a = 0.0
    !$acc end kernels
    call cpu_time(finish)
    print '("kernel setting 0 time = ",f6.3," seconds.")', (finish - start) 

    call cpu_time(start)    
    !$acc kernels present(a)
    a(:,:,:,:) = 0.0
    !$acc end kernels
    call cpu_time(finish)
    print '("kernel setting 1 time = ",f6.3," seconds.")', (finish - start) 

    call cpu_time(start)     
    !$acc kernels present(a)
    a(1:n,1:n,1:n,1:n) = 0.0
    !$acc end kernels    
    call cpu_time(finish)
    print '("kernel setting 2 time = ",f6.3," seconds.")', (finish - start) 

    !$acc exit data delete(a)
    deallocate(a)
end program main

