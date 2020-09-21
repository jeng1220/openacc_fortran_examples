out=hybrid_omp_acc

all: $(out)

hybrid_omp_acc: hybrid_omp_acc.f90
	pgf90 -acc -fast -mp -ta=tesla -Minfo=accel,mp $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
