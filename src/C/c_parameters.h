extern double *atoms;
extern double *copy_atoms;
extern double sim_time;
extern double *force;

extern struct settings run_settings;
extern struct measures *ptr_measure;

extern char *filename_index;
extern char *filename_measure;
extern char *filename_positions;

struct measures {
	
	double temperature;
	double pressure;
	double kinetic_energy;
	double potential_energy;
	double momentum;
	double momentum_vector[3];
	
};

struct settings{
	
	int64_t index;
	int64_t n_atoms;
	double boxlength;
	double temperature_required;
	double temperature_tolerance;
	double step;
	int64_t integrator;	
	
};
