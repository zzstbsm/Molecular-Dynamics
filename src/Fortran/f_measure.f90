SUBROUTINE f_measures_link(ptr_measure) BIND(C,NAME="f_measures_link")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	TYPE(measures), POINTER, INTENT(OUT)	:: ptr_measure
	
	ptr_measure => measure
	
	RETURN
END SUBROUTINE

SUBROUTINE f_measures_update() BIND(C,NAME="f_measures_update")
	
	USE iso_c_binding
	
	USE f_parameters
	USE f_physics
	
	IMPLICIT NONE
	
	LOGICAL :: flagComputeDistance
	INTEGER	:: i,j,k
	! distance è la distanza, direction è il versore della forza
	DOUBLE PRECISION	:: distance, direction(1:3)
	DOUBLE PRECISION	:: temp, temp_pressure, temp_force
	
	! Compute kinetic energy
	measure%kinetic_energy = 0
	DO i=1,n_atoms
		DO j = 4,6
			measure%kinetic_energy = measure%kinetic_energy + copy_atoms(j,i)**2
		END DO
	END DO
	measure%kinetic_energy = measure%kinetic_energy*mass/2
	
	! Compute temperature
	measure%temperature	= 2*measure%kinetic_energy/(3*kb*n_atoms)
	
	! Compute momentum
	measure%momentum_vector(1:3) = 0
	DO i=1,n_atoms
		measure%momentum_vector(1:3) = measure%momentum_vector(1:3) + copy_atoms(4:6,i)
	END DO
	measure%momentum_vector(:) = measure%momentum_vector(:)/n_atoms
	measure%momentum = SQRT(dot_product(measure%momentum_vector(:),measure%momentum_vector(:)))
	
	! Compute  potential energy and pressure
	measure%potential_energy = 0
	temp_pressure = 0
	DO i=1,n_atoms
		DO j=i+1,n_atoms
			
			flagComputeDistance = .TRUE.
			! Check if the computation of the distance is needed for the couple
			DO k=1,3
				direction(k) = ABS(copy_atoms(k,i)-copy_atoms(k,j))
				IF (direction(k) > cutOff) THEN
					IF (direction(k) < (boxLength-cutOff)) THEN
						flagComputeDistance = .FALSE.
						EXIT
					ELSE
						direction(k) = boxlength - direction(k)
					END IF
				END IF
			END DO
			
			IF (flagComputeDistance .eqv. .TRUE.) THEN
!~ 				CALL calc_distance(distance,direction(:),copy_atoms(:,i),copy_atoms(:,j))
				distance = SQRT(DOT_PRODUCT(direction,direction))
			ELSE
				CYCLE
			END IF

			IF (distance .le. cutOff) THEN
				temp = sigma/distance
				temp_force = 4 * &
					( ((temp)**12 * 12) &
					- ((temp)**6 * 6) )
				
				! Compute potential energy
				measure%potential_energy = measure%potential_energy + 4 * eps * (temp**12 - temp**6 + constPot)
				
				! This part is needed for the computation of the pressure (theorem of the virial)
				temp_pressure = temp_pressure + temp_force
				
			END IF
			
		END DO
	END DO
	
	! Compute pressure
	measure%pressure = (2*measure%kinetic_energy+temp_pressure)/(3*(boxlength**3))
	
	RETURN
	
END SUBROUTINE

SUBROUTINE f_copy_atoms_update() BIND(C,NAME="f_copy_atoms_update")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	copy_atoms = atoms
	
END SUBROUTINE f_copy_atoms_update

SUBROUTINE f_copy_atoms_init(ptr_copy_atoms) BIND(C,NAME="f_copy_atoms_init")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), POINTER 	:: ptr_copy_atoms
	
	IF (ALLOCATED(copy_atoms)) THEN
		DEALLOCATE(copy_atoms)
	END IF
	
	ALLOCATE(copy_atoms(1:6,1:n_atoms))
	copy_atoms = atoms
	
	ptr_copy_atoms => copy_atoms(1,1)
	
	RETURN
	
END SUBROUTINE f_copy_atoms_init
