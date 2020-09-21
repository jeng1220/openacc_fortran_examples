subroutine foo()
    use cudafor
    implicit none

    integer i, j, k, n
    real, allocatable, contiguous, dimension(:,:) :: data

    n = 10000
    allocate(data(n, n))
    !$acc enter data create(data(n, n))

    do k = 1, 100
      if (k .eq. 10) then
        call cudaProfilerStart()
      end if

      !$acc parallel loop present(data(n, n))
      do j=1, n
        !$acc loop independent 
        do i=1, n
          data(i, j) = data(i, j) + 1
        end do
      end do


      if (k .eq. 20) then
        call cudaProfilerStop()
      end if
    end do

    !$acc exit data delete(data)
    deallocate(data)
end subroutine

program main
    implicit none
    call foo
end program main

