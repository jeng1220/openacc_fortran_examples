out = mpi_sendrecv
all: $(out)

mpi_sendrecv: mpi_sendrecv.f90
	mpif90 $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
