module bar
    implicit none
    public
    integer, allocatable :: var
    !$acc declare present(var)
contains
end module
