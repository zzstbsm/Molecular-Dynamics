MODULE f_parameters
	
	USE iso_c_binding
	
	TYPE, BIND(C) :: measures
		REAL(KIND=C_DOUBLE)	:: temperature
		REAL(KIND=C_DOUBLE)	:: pressure
		REAL(KIND=C_DOUBLE)	:: kinetic_energy
		REAL(KIND=C_DOUBLE)	:: potential_energy
		REAL(KIND=C_DOUBLE)	:: momentum
		REAL(KIND=C_DOUBLE)	:: momentum_vector(1:3)
	END TYPE measures
	
	!
	
	DOUBLE PRECISION, PARAMETER	:: eps = 1.
	DOUBLE PRECISION, PARAMETER	:: sigma = 1.
	DOUBLE PRECISION, PARAMETER	:: mass = 1.
	DOUBLE PRECISION, PARAMETER	:: kb = 1
	DOUBLE PRECISION, PARAMETER	:: cutOff = 2.
	
	INTEGER, PARAMETER	:: PI=3.141592654
	
	!
	
	TYPE(measures), TARGET	:: measure
	
	REAL(KIND=C_DOUBLE), ALLOCATABLE, TARGET	:: atoms(:,:)
	REAL(KIND=C_DOUBLE), ALLOCATABLE, TARGET	:: copy_atoms(:,:)
	REAL(KIND=C_DOUBLE), ALLOCATABLE, TARGET	:: force(:,:)
	REAL(KIND=C_DOUBLE)							:: constPot = -(((sigma/cutOff)**12)-((sigma/cutOff)**6))
	
	INTEGER(KIND=C_INT64_T)	:: n_atoms
	REAL(KIND=C_DOUBLE)	:: boxLength				! Length of the box
	REAL(KIND=C_DOUBLE)	:: lattice_step 			! Step of the lattice after initialization
	REAL(KIND=C_DOUBLE)	:: time						! Internal clock
	REAL(KIND=C_DOUBLE)	:: required_temperature		! Required temperature from the exterior
	
END MODULE f_parameters

SUBROUTINE f_par_set_n_atoms(set_n_atoms) BIND(C,NAME="f_par_set_n_atoms")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	INTEGER(KIND=C_INT64_T), INTENT(IN) ::	set_n_atoms
	
	n_atoms = set_n_atoms
	
END SUBROUTINE f_par_set_n_atoms

SUBROUTINE f_par_get_n_atoms(get_n_atoms) BIND(C,NAME="f_par_get_n_atoms")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	INTEGER(KIND=C_INT64_T), INTENT(OUT) ::	get_n_atoms
	
	get_n_atoms = n_atoms
	
END SUBROUTINE f_par_get_n_atoms

SUBROUTINE f_par_set_boxlength(set_boxlength) BIND(C,NAME="f_par_set_boxlength")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(IN) ::	set_boxlength
	
	boxlength = set_boxlength
	
END SUBROUTINE f_par_set_boxlength

SUBROUTINE f_par_get_boxlength(get_boxlength) BIND(C,NAME="f_par_get_boxlength")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(OUT) ::	get_boxlength
	
	get_boxlength = boxlength
	
END SUBROUTINE f_par_get_boxlength

SUBROUTINE f_par_get_lattice_step(get_lattice_step) BIND(C,NAME="f_par_get_lattice_step")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(OUT) ::	get_lattice_step
	
	get_lattice_step = lattice_step
	
END SUBROUTINE f_par_get_lattice_step

SUBROUTINE f_par_set_time(set_time) BIND(C,NAME="f_par_set_time")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(IN) ::	set_time
	
	time = set_time
	
END SUBROUTINE f_par_set_time

SUBROUTINE f_par_get_time(get_time) BIND(C,NAME="f_par_get_time")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(OUT) ::	get_time
	
	get_time = time
	
END SUBROUTINE f_par_get_time

SUBROUTINE f_par_set_required_temperature(set_temperature) BIND(C,NAME="f_par_set_required_temperature")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(IN) ::	set_temperature
	
	required_temperature = set_temperature
	
END SUBROUTINE f_par_set_required_temperature
