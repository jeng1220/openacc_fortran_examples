out = nccl_alltoall
all: $(out)

nccl_alltoall: nccl_alltoall.f90
	mpif90 -acc -fast -ta=tesla:managed -Mcuda -cudalib=nccl $^ -o $@ 

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
