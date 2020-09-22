out=atomic_op

all: $(out)

atomic_op: atomic_op.f90
	pgf90 -acc -fast -ta=tesla -Minfo=accel $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
