out=cuda_graph

all: $(out)

cuda_graph: cuda_graph.f90
	pgf90 -acc -ta=tesla -Minfo=accel $^ -Mcuda -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
