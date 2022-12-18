MODULE f_physics
	
	USE f_parameters
	USE iso_c_binding
	
CONTAINS

!~ 	SUBROUTINE calc_distance(distance,direction,position1,position2)
		
!~ 		IMPLICIT NONE

!~ 		REAL(KIND=C_DOUBLE), INTENT(IN)	:: position1(1:3)
!~ 		REAL(KIND=C_DOUBLE), INTENT(IN)	:: position2(1:3)

!~ 		REAL(KIND=C_DOUBLE), INTENT(OUT)	:: distance
!~ 		! Direction non è normalizzato
!~ 		REAL(KIND=C_DOUBLE), INTENT(OUT)	:: direction(1:3)
		
!~ 		REAL(KIND=C_DOUBLE)	:: halfBox
		
!~ 		! n assume valori che indicano se il secondo atomo va spostato e dove (condizioni periodiche
!~ 		! a destra o a sinistra
!~ 		INTEGER				:: n(1:3)
!~ 		REAL(KIND=C_DOUBLE)	:: dist(1:3)

!~ 		! Contatori
!~ 		INTEGER		:: i

!~ 		halfBox = boxLength/2

!~ 		! Se la differenza delle coordinate tra le due particelle su una direzione è maggiore halfBox, sposta 
!~ 		! la particella 2 a seconda della posizione della particella 1 rispetto alla particella (lo spostamento
!~ 		! avviene impostando un valore idoneo sulla variabile n)

!~ 		! Verifica che il secondo atomo sia nel cubo
!~ 		DO i=1,3
			
!~ 			dist(i) = ABS(position1(i)-position2(i))
			
!~ 			! La distanza è minore di halfBox
!~ 			IF (dist(i)<halfBox) THEN
!~ 				n(i) = 0
!~ 			! La distanza è maggiore di halfBox, sposta gli atomi
!~ 			ELSE
!~ 				dist(i) = boxLength-dist(i)
!~ 				! La particella 2 va spostata a sinistra dato che si trova a destra
!~ 				IF (position2(i)>position1(i)) THEN
!~ 					n(i) = -1
!~ 				! La particella 2 va spostata a destra dato che si trova a sinistra
!~ 				ELSE IF (position2(i)<position1(i)) THEN
!~ 					n(i) = +1
!~ 				END IF
!~ 			END IF

!~ 		END DO

!~ 		! Calcola la distanza
!~ 		direction = (position2-position1+n*boxLength)
!~ 		distance = SQRT(DOT_PRODUCT(dist,dist))

!~ 	END SUBROUTINE calc_distance

	SUBROUTINE calc_force_2_partices(int_force,position1,position2)

		IMPLICIT NONE

		DOUBLE PRECISION, INTENT(IN)	:: position1(1:3)
		DOUBLE PRECISION, INTENT(IN)	:: position2(1:3)

		DOUBLE PRECISION, INTENT(OUT)	:: int_force(1:3)

		! distance è la distanza, direction è il versore della forza
		DOUBLE PRECISION	:: distance
		DOUBLE PRECISION	:: direction(1:3), temp
		
		LOGICAL :: flagComputeDistance
		INTEGER	:: i
		
		flagComputeDistance = .TRUE.
		DO i=1,3
			direction(i) = position2(i)-position1(i)
			IF (ABS(direction(i)) > cutOff) THEN
				IF (ABS(direction(i)) < (boxLength-cutOff)) THEN
					flagComputeDistance = .FALSE.
					EXIT
				ELSE
					IF (direction(i) > 0) THEN
						direction(i) = direction(i) - boxlength
					ELSE
						direction(i) = direction(i) + boxlength
					END IF
				END IF
			END IF
		END DO
		
		IF (flagComputeDistance .eqv. .TRUE.) THEN
!~ 			CALL calc_distance(distance,direction(:),position1(:),position2(:))
			distance = SQRT(DOT_PRODUCT(direction,direction))
		ELSE
			int_force = 0
			RETURN
		END IF

		IF (distance>cutOff) THEN
			int_force = 0
		ELSE
			temp = sigma/distance
			int_force = 4 * &
				( ((temp)**12 * 12) &
				- ((temp)**6 * 6) ) &
				*direction/(distance**2)
		END IF
		
	END SUBROUTINE calc_force_2_partices
	
	SUBROUTINE calc_force(x)
		
		IMPLICIT NONE
		
		REAL(KIND=C_DOUBLE), INTENT(IN)	:: x(1:6,1:n_atoms)
		DOUBLE PRECISION	:: tempVec(1:3)

		INTEGER	:: i, j
		
		! Calcola la forza: decide quale forze vanno valutate e valuta quelle
		force = 0
		
		DO i=1,n_atoms,+1
			DO j=i+1,n_atoms,+1
				CALL calc_force_2_partices(tempVec(:),atoms(1:3,i),atoms(1:3,j))
				force(:,i) = force(:,i) - tempVec
				force(:,j) = force(:,j) + tempVec
				
			END DO
		END DO
		
	END SUBROUTINE calc_force
	
	SUBROUTINE dynamic(xPrime,x,t)
		
		IMPLICIT NONE

		DOUBLE PRECISION, INTENT(OUT)	:: xPrime(1:6,1:n_atoms)
		DOUBLE PRECISION, INTENT(IN)	:: x(1:6,1:n_atoms)
		DOUBlE PRECISION, INTENT(IN)	:: t
		
		INTEGER	:: i
		
		CALL calc_force(x(:,:))
		
		DO i=1,3
			xPrime(i,:) = x(i+3,:)
			xPrime(i+3,:) = force(i,:)
		END DO
		

	END SUBROUTINE dynamic

END MODULE f_physics

SUBROUTINE verlet(func,t,step)
	
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(IN)	:: t, step
	
	DOUBLE PRECISION	:: k1(1:6,1:n_atoms),k2(1:6,1:n_atoms)
	
	! Evaluate coefficients
	k1 = 0
	k2 = 0
	CALL func(k1(:,:),atoms(:,:),t)
	
	! k1(4:6,:) is the acceleration
	atoms(1:3,:) = atoms(1:3,:) + atoms(4:6,:)*step + (k1(4:6,:)*step**2)/2
	CALL func(k2(:,:),atoms(:,:),t+step)
	atoms(4:6,:) = atoms(4:6,:) + (k1(4:6,:)+k2(4:6,:))*step/2
	
END SUBROUTINE verlet

SUBROUTINE f_run_step(t,step,integrator) BIND(C,NAME="f_run_step")
	
	USE f_parameters
	USE f_physics
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(IN)	:: t, step
	INTEGER(KIND=C_INT64_T), INTENT(IN) :: integrator
	
	IF (integrator == 1) THEN
		CALL verlet(dynamic,t,step)
		CALL periodic_conditions()
	END IF
	
END SUBROUTINE f_run_step

SUBROUTINE f_adjust_temperature() BIND(C,NAME="f_adjust_temperature")
	
	USE f_parameters
	
	IMPLICIT NONE
	
	atoms(4:6,:) = atoms(4:6,:) * SQRT(required_temperature/measure%temperature)
	
END SUBROUTINE f_adjust_temperature

SUBROUTINE f_adjust_boxlength(new_length) BIND(C,NAME="f_adjust_boxlength")
	
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(IN)	:: new_length
	
	atoms(1:3,:) = atoms(1:3,:)*new_length/boxlength
	boxlength = new_length
	
END SUBROUTINE f_adjust_boxlength
