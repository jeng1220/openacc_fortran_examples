out = nccl_alltoallv
all: $(out)

nccl_alltoallv: nccl_alltoallv.f90
	mpif90 -acc -fast -ta=tesla -Minfo=accel -Mcuda -cudalib=nccl $^ -o $@ 

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
