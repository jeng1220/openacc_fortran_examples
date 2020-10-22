out = cuda_unified_memory_mpi_bcast
all: $(out)

cuda_unified_memory_mpi_bcast: cuda_unified_memory_mpi_bcast.f90
	mpif90 -acc -fast -ta=tesla:managed -Minfo=accel -Mcuda $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
