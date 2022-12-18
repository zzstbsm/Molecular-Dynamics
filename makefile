COMPILE_FLAGS=-ggdb -O0

cpath=src/C/
fpath=src/Fortran/

molecular_dynamics: \
	c_folders.o \
	c_main.o \
	c_measure.o \
	c_parameters.o \
	c_run_type.o \
	c_structure.o \
	\
	f_parameters.o \
	f_physics.o \
	\
	f_measure.o \
	f_positions.o
	gfortran \
		c_folders.o \
		c_main.o \
		c_measure.o \
		c_parameters.o \
		c_run_type.o \
		c_structure.o \
		f_measure.o \
		f_parameters.o \
		f_physics.o \
		f_positions.o \
		-o molecular_dynamics 

c_folders.o: $(cpath)c_folders.c
	gcc -c $(cpath)c_folders.c $(COMPILE_FLAGS)

c_main.o: $(cpath)c_main.c
	gcc -c $(cpath)c_main.c $(COMPILE_FLAGS)
	
c_measure.o: $(cpath)c_measure.c
	gcc -c $(cpath)c_measure.c $(COMPILE_FLAGS)
	
c_parameters.o: $(cpath)c_parameters.c
	gcc -c $(cpath)c_parameters.c $(COMPILE_FLAGS)
	
c_run_type.o: $(cpath)c_run_type.c
	gcc -c $(cpath)c_run_type.c $(COMPILE_FLAGS)

c_structure.o: $(cpath)c_structure.c
	gcc -c $(cpath)c_structure.c $(COMPILE_FLAGS)
	
f_measure.o: $(fpath)f_measure.f90
	gfortran -c $(fpath)f_measure.f90 $(COMPILE_FLAGS)

f_parameters.o: $(fpath)f_parameters.f90
	gfortran -c $(fpath)f_parameters.f90 $(COMPILE_FLAGS)
	
f_physics.o: $(fpath)f_physics.f90
	gfortran -c $(fpath)f_physics.f90 $(COMPILE_FLAGS)
	
f_positions.o: $(fpath)f_positions.f90
	gfortran -c $(fpath)f_positions.f90 $(COMPILE_FLAGS)

clean:
	rm *.o *.mod
