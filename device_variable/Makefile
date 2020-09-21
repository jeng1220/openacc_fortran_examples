out=device_variable

all: $(out)

device_variable: device_variable.f90 
	pgf90 -acc -fast -ta=tesla:manage -Minfo=accel -Mcuda $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
