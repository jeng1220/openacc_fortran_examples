out=acc_async

all: $(out)

acc_async: acc_async.f90
	pgf90 -acc -ta=tesla:pinned -Minfo=accel $^ -Mcuda -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
