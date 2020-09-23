program main
  use iso_c_binding
  implicit none

  interface c_interface
    subroutine my_c_func(buf, w, h) bind(C, name="my_c_func")
      use iso_c_binding
      implicit none

      integer(c_int), intent(out), dimension(*) :: buf
      integer(c_int), intent(out) :: w, h
    end subroutine my_c_func
  end interface c_interface

  integer(c_int), allocatable :: buf(:, :)
  integer(c_int) :: x, y, w, h

  w = 5
  h = 3
  allocate(buf(w, h))

  do y = 1, h
  do x = 1, w
    buf(x, y) = (y - 1) * (2 * w) + (x - 1)
  end do
  end do

  print *, 'print from fortran:\n', buf
  call my_c_func(buf, w, h)
  print *, 'after CUDA C function, print from fortran:\n', buf

  deallocate(buf)
end program main
