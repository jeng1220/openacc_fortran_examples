out = cuda_mpi_allreduce
all: $(out)

cuda_mpi_allreduce: cuda_mpi_allreduce.f90
	mpif90 -acc -fast -ta=tesla -Minfo=accel $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
