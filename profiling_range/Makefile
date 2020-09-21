out = profiling_range
all: $(out)

profiling_range: profiling_range.f90
	pgf90 -acc -fast -ta=tesla -Minfo=accel -Mcuda $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
