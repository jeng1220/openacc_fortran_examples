out=c_binding

all: $(out)

c_binding: c_binding.f90 c_func.c
	pgf90 -c -fast -acc -ta=tesla:managed -Minfo=accel c_binding.f90
	pgcc -c -fast -acc -ta=tesla:managed c_func.c
	pgf90 -acc -ta=tesla:managed -Minfo=accel -Mcuda c_binding.o c_func.o -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
