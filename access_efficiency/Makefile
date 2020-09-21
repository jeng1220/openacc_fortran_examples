out = access_efficiency
all: $(out)

access_efficiency: access_efficiency.f90
	pgf90 -acc -fast -ta=tesla -Minfo=accel $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
