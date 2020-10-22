out = cuda_mpi_sendrecv
all: $(out)

cuda_mpi_sendrecv: cuda_mpi_sendrecv.f90
	mpif90 -acc -fast -ta=tesla -Minfo=accel -Mcuda $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
