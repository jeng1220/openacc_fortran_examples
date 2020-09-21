out=auto_nvtx

all: $(out)

auto_nvtx: auto_nvtx.f90 nvtx.cpp
	pgc++ -c -fast -Wl,--export-dynamic -Mcuda nvtx.cpp
	pgf90 -c -fast -Minstrument=functions -Mfree -Mpreprocess auto_nvtx.f90
	pgf90 auto_nvtx.o nvtx.o -Wl,--export-dynamic -Mcuda -lnvToolsExt -ldl -o $@

clean:
	rm -f $(out) *.mod *.o *.pdb a.out *.obj *.dwf *.exe
