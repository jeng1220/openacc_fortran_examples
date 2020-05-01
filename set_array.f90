subroutine foo(a, b, n)
    implicit none
    integer :: n
    real :: a(n,n,n,n)
    real :: b(n,n,n,n)
    integer :: i, j, k, l, m
    do m = 1, 100   
        !$acc parallel
        a = 0.0
        b = 0.0
        !$acc end parallel
    
        !$acc parallel
        a(:,:,:,:) = 0.0
        b(:,:,:,:) = 0.0
        !$acc end parallel
    
        !$acc parallel
        a(1:n,1:n,1:n,1:n) = 0.0
        b(1:n,1:n,1:n,1:n) = 0.0
        !$acc end parallel
    
        !$acc parallel
        !$acc loop collapse(4)
        do l = 1, 100
        do k = 1, 100
        do j = 1, 100
        do i = 1, 100
            a(i,j,k,l) = 0.0
            b(i,j,k,l) = 0.0
        end do
        end do
        end do
        end do
        !$acc end parallel
    
        !$acc kernels
        a = 0.0
        b = 0.0
        !$acc end kernels
    
        !$acc kernels
        a(:,:,:,:) = 0.0
        b(:,:,:,:) = 0.0
        !$acc end kernels
    
        !$acc kernels
        a(1:n,1:n,1:n,1:n) = 0.0
        b(1:n,1:n,1:n,1:n) = 0.0
        !$acc end kernels    
    end do

end subroutine foo

program main
    implicit none
    integer :: n
    real, allocatable, dimension(:,:,:,:) :: a, b

    n = 100
    allocate(a(n,n,n,n))
    allocate(b(n,n,n,n))
    call foo(a, b, n)
    deallocate(a, b)

end program main
