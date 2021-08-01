program main
implicit none
    type intptr
        integer, pointer :: ptr(:)
    end type intptr

    type(intptr), allocatable :: array_of_pointers(:)
    integer, target, allocatable :: array1(:)
    integer, target, allocatable :: array2(:)
    integer, target, allocatable :: array3(:)
    integer :: i, n1, n2, n3

    n1 = 5
    n2 = 3
    n3 = 6

    allocate(array1(n1))
    array1(:) = n1
    allocate(array2(n2))
    array2(:) = n2
    allocate(array3(n3))
    array3(:) = n3

    allocate(array_of_pointers(3))
    array_of_pointers(1)%ptr => array1
    array_of_pointers(2)%ptr => array2
    array_of_pointers(3)%ptr => array3

    print*, 'array of pointers:'
    do i = 1, 3
        print*, array_of_pointers(i)%ptr
    end do

    deallocate(array_of_pointers)
    deallocate(array1)
    deallocate(array2)
    deallocate(array3)

end program  main
