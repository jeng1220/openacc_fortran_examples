out=device_routine

all: $(out)

device_routine: device_routine.f90 
	pgf90 -acc -fast -ta=tesla -Minfo=accel -Mcuda $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
