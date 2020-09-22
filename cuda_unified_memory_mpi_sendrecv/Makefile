out = cuda_unified_memory_mpi_sendrecv
all: $(out)

cuda_unified_memory_mpi_sendrecv: cuda_unified_memory_mpi_sendrecv.f90
	mpif90 -acc -fast -ta=tesla:managed -Minfo=accel $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
