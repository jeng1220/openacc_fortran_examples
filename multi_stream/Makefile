out=multi_stream

all: $(out)

multi_stream: multi_stream.f90
	pgf90 -acc -ta=tesla:pinned -Minfo=accel $^ -Mcuda -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
