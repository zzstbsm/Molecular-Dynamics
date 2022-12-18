#include <stdio.h>

#include <stdint.h>
#include <string.h>

#include "c_measure.h"
#include "c_parameters.h"
#include "c_run_type.h"
#include "c_structure.h"

#include "f_subroutine.h"

void run(int type){
	
	int64_t lattice_type = 2;
	
	extern double sim_time;
	
	extern struct settings run_settings;
	extern struct measures *ptr_measure;
	
	double temperatureMax;
	double temperatureMin;
	
	char file_name[20];
	
	// Set runtime settigns
	temperatureMax = run_settings.temperature_required*(1+run_settings.temperature_tolerance);
	temperatureMin = run_settings.temperature_required*(1-run_settings.temperature_tolerance);
	
	// New run
	if (type  == 1){
		// Create lattice
		structure_create(lattice_type);
		printf("Structure created\n");
		
		// Generate index
		strcpy(file_name,"data/prova.bin\0");
		
		// Save initial configuration
		structure_save(file_name);
		printf("File saved\n");
	}
	// Load run
	else if (type = 2) {
		printf("To implement");
		return;
	}
	
	// Evolve the system
	printf(" Time | Energy | Kinetic energy | Potential energy | Temperature | Pressure \n");
	for (int i=0; i < 200000; i++){
		if (!(i%500)) {
			measures_update();
			measures_print();
			
			if (run_settings.temperature_tolerance != 0
					&&
					(
						(ptr_measure->temperature > temperatureMax)
						||
						(ptr_measure->temperature < temperatureMin)
					)
				) {
				f_adjust_temperature();
				i = 0;
				sim_time = 0;
				//~ f_par_set_time(&sim_time);
				//~ structure_save(file_name);
				printf("Rescale velocities to match the target temperature\n");
				printf(" Time | Energy | Kinetic energy | Potential energy | Temperature | Pressure \n");
				measures_print();
				measures_update();
			}
			structure_append(file_name);
		}
		f_run_step(&sim_time,&run_settings.step,&run_settings.integrator);
		sim_time += run_settings.step;
	}
	
	structure_append(file_name);
	
	return;	
	
}

void show_runs(){
	
	printf("Show runs\n");
	return;
	
}
