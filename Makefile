TA=tesla
out=openacc_nested_loop mpi_basic cuda_graph parallel_call async mix_cpu_gpu_parallel instrument_function set_array f_call_c
CUDA_ROOT=/usr/local/cuda

all: $(out)

openacc_nested_loop: openacc_nested_loop.f90
	pgf90 -acc -ta=tesla -Minfo=accel -O4 $^ -o $@

mpi_basic: mpi_basic.f90
	mpif90 $^ -o $@

cuda_graph: cuda_graph_m.f90 main_graph.f90
	pgf90 -acc -ta=tesla:managed -Minfo=accel $^ -Mcuda -o $@

parallel_call: parallel_call.f90 mod_bar.f90
	pgf90 -acc -ta=tesla:managed -Minfo=accel -Mcuda -c mod_bar.f90
	pgf90 -acc -ta=tesla:managed -Minfo=accel -Mcuda -c parallel_call.f90
	pgf90 -acc -ta=tesla:managed -Minfo=accel -Mcuda parallel_call.o mod_bar.o -o $@

async: async.f90
	pgf90 -acc -ta=tesla:managed -Minfo=accel -Mcuda -Mpreprocess $^ -o $@

mix_cpu_gpu_parallel: mix_cpu_gpu_parallel.f90
	pgf90 -acc -mp -ta=tesla:managed -Minfo=accel,mp $^ -o $@

instrument_function: instrument_function.f90 nvtx.cpp
	pgc++ -c -O0 -Wl,--export-dynamic -I$(CUDA_ROOT)/include nvtx.cpp
	pgf90 -c -O0 -Minstrument=functions -Mfree -r8 -Mpreprocess instrument_function.f90
	pgf90 instrument_function.o nvtx.o -Wl,--export-dynamic -L$(CUDA_ROOT)/lib64 -lnvToolsExt -ldl -o $@

set_array: set_array.f90
	pgf90 -acc -ta=tesla:managed -Minfo=accel -Mcuda -Mpreprocess -O3 $^ -o $@

f_call_c: f_call_c.f90 cfun.c
	pgf90 -c -O0 -g -acc -ta=tesla:managed -Minfo=accel -Mcuda -Mpreprocess f_call_c.f90
	pgcc -c -O0 -g -acc -ta=tesla:managed cfun.c
	pgf90 -acc -ta=tesla:managed -Minfo=accel -Mcuda -Mpreprocess f_call_c.o cfun.o -o $@


clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
