SUBROUTINE f_positions_create(ptr_atoms,ptr_forces,lattice_type) BIND(C,NAME="f_positions_create")
	
	USE iso_c_binding
	
	USE f_parameters
	USE f_physics

	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), POINTER, INTENT(OUT)	:: 	ptr_atoms,ptr_forces
	INTEGER(KIND=C_INT64_T), INTENT(IN)				:: 	lattice_type
	
	! For velocity
	DOUBLE PRECISION	:: v, phi, theta
	DOUBLE PRECISION	:: totVel(1:3)
	
	INTEGER	:: i
	
	ALLOCATE(atoms(1:6,1:n_atoms))
	ptr_atoms => atoms(1,1)
	ALLOCATE(force(1:3,1:n_atoms))
	ptr_forces => force(1,1)
	
	IF (lattice_type == 1) THEN
		! Simple cubic
		CALL simple_cubic()
	ELSE IF (lattice_type == 2) THEN
		! FCC
		CALL FCC()
	ELSE
		RETURN
	END IF
	
	! Generate velocities
	DO i=1,n_atoms
		
		CALL RANDOM_NUMBER(v)
		CALL RANDOM_NUMBER(phi)
		CALL RANDOM_NUMBER(theta)
		
		phi = phi*2*PI
		theta = theta*PI
		
		atoms(4,i) = v*SIN(theta)*COS(phi)
		atoms(5,i) = v*SIN(theta)*SIN(phi)
		atoms(6,i) = v*COS(theta)

	END DO
	
	IF (n_atoms == 2) THEN
		atoms(:,1) = (/2d0, 0d0, 0d0, -1d0, 0d0, 0d0/)
		atoms(:,2) = (/8d0 , 9d0 , 0d0, 1d0, 0d0, 0d0/)
	END IF
		
	! Fix the center of mass
	totVel = 0
	DO i=1,n_atoms
		totVel = totVel + atoms(4:6,i)
	END DO
	totVel = totVel/n_atoms
	
	DO i=1,n_atoms
		atoms(4:6,i) = atoms(4:6,i) - totVel
	END DO
	
	RETURN

END SUBROUTINE f_positions_create

SUBROUTINE f_positions_load(ptr_atoms,tmp_atoms,ptr_forces) BIND(C,NAME="f_positions_load")
	
	USE iso_c_binding
	
	USE f_physics
	USE f_parameters

	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), POINTER, INTENT(OUT)	:: 	ptr_atoms, ptr_forces
	REAL(KIND=C_DOUBLE), INTENT(IN)				::	tmp_atoms(1:6,1:n_atoms)
	
	IF (ALLOCATED(atoms)) THEN
		DEALLOCATE(atoms)
	END IF
	
	IF (ALLOCATED(force)) THEN
		DEALLOCATE(force)
	END IF
	
	ALLOCATE(atoms(1:6,1:n_atoms))
	ptr_atoms => atoms(1,1)
	
	ALLOCATE(force(1:3,1:n_atoms))
	ptr_forces => force(1,1)
	
	atoms = tmp_atoms
	
	RETURN

END SUBROUTINE f_positions_load

SUBROUTINE periodic_conditions()

	USE f_parameters

	IMPLICIT NONE

	INTEGER				:: i, j, n

	DO i=1,n_atoms
		DO j=1,3
			n = FLOOR(atoms(j,i)/boxLength)
			atoms(j,i) = atoms(j,i) - n*boxLength
		END DO
	END DO

END SUBROUTINE periodic_conditions

SUBROUTINE simple_cubic()
	
	USE f_parameters
	
	IMPLICIT NONE
	
	INTEGER	:: i, ix, iy, iz
	
	INTEGER	:: atoms_per_edge
	
	atoms_per_edge = CEILING(n_atoms**(1.0/3))
	
	ix = 1
	iy = 1
	iz = 1
	i = 1
	
	DO WHILE (i .le. n_atoms)
		
		IF (ix > atoms_per_edge) THEN
			ix = ix - atoms_per_edge
			iy = iy + 1
			
			IF (iy > atoms_per_edge) THEN
				iy = iy - atoms_per_edge
				iz = iz + 1
			END  IF
			
		END IF
		
		atoms(1,i) = REAL(ix)
		atoms(2,i) = REAL(iy)
		atoms(3,i) = REAL(iz)
		
		ix = ix+1
		i = i+1
		
	END DO
	
	! Normalize according to boxlength
	atoms(1:3,:) = atoms(1:3,:)*boxlength/atoms_per_edge
	
	! Set lattice spacing
	lattice_step = boxlength/atoms_per_edge
	
END SUBROUTINE simple_cubic

SUBROUTINE FCC()
	
	USE f_parameters
	
	IMPLICIT NONE
	
	INTEGER	:: i, ix, iy, iz
	
	INTEGER	:: atoms_per_edge
	
	atoms_per_edge = CEILING((n_atoms/4.)**(1.0/3))
	
	ix = 0
	iy = 0
	iz = 0
	i = 1
	
	DO WHILE (i .le. n_atoms)
		
		IF (ix .ge. atoms_per_edge) THEN
			ix = ix - atoms_per_edge
			iy = iy + 1
			
			IF (iy .ge. atoms_per_edge) THEN
				iy = iy - atoms_per_edge
				iz = iz + 1
								
			END  IF
			
		END IF
		
		atoms(1,i) = REAL(ix)
		atoms(2,i) = REAL(iy)
		atoms(3,i) = REAL(iz)
		i = i+1
		
		IF (i .le. n_atoms) THEN
			atoms(1,i) = REAL(ix)+0.5
			atoms(2,i) = REAL(iy)+0.5
			atoms(3,i) = REAL(iz)
			i = i+1
		ELSE
			EXIT
		END IF
		
		IF (i .le. n_atoms) THEN
			atoms(1,i) = REAL(ix)+0.5
			atoms(2,i) = REAL(iy)
			atoms(3,i) = REAL(iz)+0.5
			i = i+1
		ELSE
			EXIT
		END IF
		
		IF (i .le. n_atoms) THEN
			atoms(1,i) = REAL(ix)
			atoms(2,i) = REAL(iy)+0.5
			atoms(3,i) = REAL(iz)+0.5
			i = i+1
		ELSE
			EXIT
		END IF
		
		ix = ix+1
		
	END DO
	
	! Normalize according to boxlength
	atoms(1:3,:) = atoms(1:3,:)*boxlength/atoms_per_edge
	
	! Set lattice spacing
	lattice_step = boxlength/atoms_per_edge*SQRT(2.)/2
	
	CALL periodic_conditions()
	
	RETURN
	
END SUBROUTINE FCC
