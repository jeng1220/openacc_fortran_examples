out=cuda_c_binding

all: $(out)

cuda_c_binding: cuda_c_binding.f90 cuda_c_func.cu
	pgf90 -c -fast -acc -ta=tesla -Minfo=accel cuda_c_binding.f90
	nvcc -c -O3 cuda_c_func.cu
	pgf90 -acc -ta=tesla -Minfo=accel -Mcuda cuda_c_binding.o cuda_c_func.o -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
