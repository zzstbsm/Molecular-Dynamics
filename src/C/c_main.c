#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "c_folders.h"
#include "c_parameters.h"
#include "c_run_type.h"

int main(int argc, char* argv[]){
	
	extern double *atoms;
	extern double *force;

	extern double sim_time;
	
	extern struct settings run_settings;
	extern struct measures *ptr_measure;
	
	// Set default parameters
	atoms = NULL;
	force = NULL;
	ptr_measure = NULL;
	
	
	
	// Default atoms number
	run_settings.n_atoms = 100;
	// Default size of the box
	run_settings.boxlength = 100;
	sim_time = 0;
	// Default integration: Verlet algorithm
	run_settings.integrator = 1;
	// Default temperature
	run_settings.temperature_required = 1;
	// Default tolerance before rescaling (zero tolerance means accept all measures)
	run_settings.temperature_tolerance = 0;
	// Default step time
	run_settings.step = 5e-3;
	
	// Set user parameters
	for (int i = 1; i < argc; i++){
		
		// Set the number of atoms
		if (!strcmp(argv[i],"--number\0")){
			run_settings.n_atoms = atoll(argv[i+1]);
			i++;
		}
		
		// Set the length of the box
		else if (!strcmp(argv[i],"--length\0")){
			run_settings.boxlength = atof(argv[i+1]);
			i++;
		}
		
		// Set the temperature
		else if (!strcmp(argv[i],"--temperature\0")){
			run_settings.temperature_required = atof(argv[i+1]);
			i++;
		}
		
		// Set tolerance
		else if (!strcmp(argv[i],"--tolerance\0")){
			run_settings.temperature_tolerance = atof(argv[i+1]);
			i++;
		}
		
		// Set the step
		else if (!strcmp(argv[i],"--step\0")){
			run_settings.step = atof(argv[i+1]);
			i++;
		}
		
		// Set integrator
		else if (!strcmp(argv[i],"--integrator\0")){
			run_settings.integrator = atoll(argv[i+1]);
			i++;
		}
		
		// Resume run
		else if (!strcmp(argv[i],"--resume\0")){
			run_settings.index = atoll(argv[i+1]);
			i++;
		}
		
		// Show the saved runs
		else if (!strcmp(argv[i],"--show_runs\0")){
			show_runs();
			return 0;
		}
		
		else {
			printf("Not recognised command\n");
			return -1;
		}
	}
	
	if (!folder_check("data")) folder_mkdir("data");
	
	// Run the program
	run(1);
	
	return 0;
	
}
