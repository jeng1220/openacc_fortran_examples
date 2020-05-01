program test_call_C

  use iso_c_binding

  implicit none

  interface c_interface

    subroutine get_filled_ar(ar, h, w) bind(C, name="get_filled_ar")

      use iso_c_binding

      implicit none

      integer(c_int), intent(out), dimension(*) :: ar
      integer(c_int), intent(out) :: h, w

    end subroutine get_filled_ar

  end interface c_interface

  integer(c_int), dimension(3, 5) :: ar
  integer(c_int) :: x, y, w, h

  w = 5
  h = 3

  do x = 1, w
  do y = 1, h
    ar(y, x) = (y-1)*5+(x-1)
  end do
  end do

  print *, 'print from fortran:'
  print *, ar

  call get_filled_ar(ar, h, w)

end program test_call_C
