#include <stdio.h>
#include <stdlib.h>

#include "c_structure.h"
#include "c_parameters.h"
#include "f_subroutine.h"

int structure_create(int64_t lattice_type){
	
	extern double *atoms;
	extern double *force;
	extern double sim_time;
	
	extern struct settings run_settings;
	
	extern struct measures *ptr_measure;
		
	// Set parameters
	f_par_set_n_atoms(&run_settings.n_atoms);
	f_par_set_boxlength(&run_settings.boxlength);
	f_par_set_required_temperature(&run_settings.temperature_required); // It just sets the temperature, it does not refresh it
	f_par_set_time(&sim_time);
	
	// Initialize position and velocity and link atoms pointer
	f_positions_create(&atoms,&force,&lattice_type);
	
	// Initialize the copy of atoms for the measurements
	f_copy_atoms_init(&copy_atoms);
	
	// Initialize the measures
	f_measures_link(&ptr_measure);
 	f_measures_update();
	
	// Creation successful
	return 0;
	
}

int structure_load(char* file_name){
	
	extern double *atoms;
	extern double *force;
	extern double sim_time;
	
	extern struct settings run_settings;
	
	double *tmp_atoms;
	
	FILE *load;
	
	load = fopen(file_name,"rb");
	
	// Read file
	
	// Read settings
	fread(&run_settings,sizeof(run_settings),1,load);
	
	// Read the time
	if (!fseek(load,
			-sizeof(double)*6*run_settings.n_atoms+sizeof(double),
			SEEK_END)) {
		return -1;
	}
	fread(&sim_time,sizeof(sim_time),1,load);
	
	// Read the atoms data
	tmp_atoms = (double*)malloc(sizeof(double)*6*run_settings.n_atoms);	
	fread(tmp_atoms,sizeof(double)*6*run_settings.n_atoms,1,load);
	
	fclose(load);
	
	// Load values in Fortran module
	f_par_set_n_atoms(&run_settings.n_atoms);
	f_par_set_boxlength(&run_settings.boxlength);
	f_par_set_required_temperature(&run_settings.temperature_required);
	
	f_positions_load(&atoms,&force,tmp_atoms);
		
	free(tmp_atoms);
	
	// Initialize the copy of atoms for the measurements
	f_copy_atoms_init(&copy_atoms);
	
	// Initialize the measures
	f_measures_link(&ptr_measure);
 	f_measures_update();
	
	// Load successful
	return 0;
}

int structure_save(char* file_name){
	
	extern double *atoms;
	extern struct settings run_settings;
	extern double sim_time;
	
	FILE *save;
	
	// Save in file
	printf("ok\n");
	save = fopen(file_name,"wb");
	
	// Save the settings of the run
	fwrite(&run_settings,sizeof(run_settings),1,save);
	
	// Save the initial conditions
	fwrite(&sim_time,sizeof(sim_time),1,save);
	fwrite(atoms,sizeof(*atoms)*6*run_settings.n_atoms,1,save);
	
	fclose(save);
	
	// Save successful
	return 0;
	
}

int structure_append(char* file_name){
	
	extern double *atoms;
	extern struct settings run_settings;
	extern double sim_time;
	
	FILE *append;
	
	// Append in file
	
	append = fopen(file_name,"ab");
	
	// Append the time
	fwrite(&sim_time,sizeof(sim_time),1,append);
	// Append the atoms positions and velocities
	fwrite(atoms,sizeof(*atoms)*6*run_settings.n_atoms,1,append);
	
	fclose(append);
	
	// Append successful
	return 0;
	
}
