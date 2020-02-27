TA=tesla
out=openacc_nested_loop mpi_basic cuda_graph parallel_call
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

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
