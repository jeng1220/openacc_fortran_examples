out=openacc_nested_loop mpi_basic
all: $(out)

openacc_nested_loop: openacc_nested_loop.f90
	pgf90 -acc -ta=tesla -Minfo=accel -O4 $^ -o $@

mpi_basic: mpi_basic.f90
	mpif90 $^ -o $@

clean:
	rm -f $(out)
