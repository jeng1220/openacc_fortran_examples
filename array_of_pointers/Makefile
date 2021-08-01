out=array_of_pointers

all: $(out)

array_of_pointers: array_of_pointers.f90
	pgf90 -Minfo=all $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
