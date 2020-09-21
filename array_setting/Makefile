out=array_setting

all: $(out)

array_setting: array_setting.f90
	pgf90 -acc -fast -ta=tesla -Minfo=accel $^ -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
