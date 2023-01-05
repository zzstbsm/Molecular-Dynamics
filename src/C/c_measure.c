#include <stdio.h>
#include <stdint.h>

#include "c_measure.h"
#include "c_parameters.h"

#include "f_subroutine.h"

void measures_link(struct measures *ptr){
	
	f_measures_link(&ptr);
	
	return;
}

void measures_update(){
	
	f_copy_atoms_update();
	f_measures_update();
	
	return;
}

int measures_save(){
	
	return 0;
	
}

void measures_print(){
	
	extern struct measures *ptr_measure;
	
	printf("%.3f | %.3f | %.3f | %.3f | %.3f | %.3f\n",
		sim_time,
		ptr_measure->kinetic_energy + ptr_measure->potential_energy,
		ptr_measure->kinetic_energy,
		ptr_measure->potential_energy,
		ptr_measure->temperature,
		ptr_measure->pressure);

}
