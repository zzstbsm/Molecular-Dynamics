variable = input("Type the variable name: ")

variable = [variable]*7*2
variable = tuple(variable)

output = """
SUBROUTINE f_par_set_%s(set_%s) BIND(C,NAME="f_par_set_%s")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(IN) ::	set_%s
	
	%s = set_%s
	
END SUBROUTINE f_par_set_%s

SUBROUTINE f_par_get_%s(get_%s) BIND(C,NAME="f_par_get_%s")
	
	USE iso_c_binding
	USE f_parameters
	
	IMPLICIT NONE
	
	REAL(KIND=C_DOUBLE), INTENT(OUT) ::	get_%s
	
	get_%s = %s
	
END SUBROUTINE f_par_get_%s
""" %variable

print(output)
