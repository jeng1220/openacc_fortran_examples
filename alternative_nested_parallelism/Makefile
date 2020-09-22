out=alternative_nested_parallelism

all: $(out)

alternative_nested_parallelism: alternative_nested_parallelism.f90
	pgf90 -acc -fast -ta=tesla -Minfo=accel $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
