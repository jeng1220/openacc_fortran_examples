program main
    use cudafor
    implicit none

    integer i, k, n
    real, allocatable :: buf(:)

    n = 1000000
    allocate(buf(n))

    do k = 1, 100
        if (k .eq. 10) then
            call cudaProfilerStart()
        end if

        !$acc parallel loop copy(buf)
        do i=1, n
            buf(i) = buf(i) + 1
        end do

        if (k .eq. 20) then
            call cudaProfilerStop()
        end if
    end do

    deallocate(buf)
end program main
