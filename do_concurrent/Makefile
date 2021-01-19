out=do_concurrent

all: $(out)

do_concurrent: do_concurrent.f90
	pgf90 -acc -stdpar -Minfo=accel $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
