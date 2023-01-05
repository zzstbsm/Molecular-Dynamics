#define CELL(i,j,n) (j*n+i)

extern void f_par_set_n_atoms(int64_t*);
extern void f_par_get_n_atoms(int64_t*);
extern void f_par_set_boxlength(double*);
extern void f_par_get_boxlength(double*);
extern void f_par_set_time(double*);
extern void f_par_get_time(double*);
extern void f_par_set_required_temperature(double*);

extern void f_par_get_lattice_step(double*);

extern void f_positions_create(double**,double**,int64_t*);
extern void f_positions_load(double**,double**,double*);

extern void f_run_step(double*,double*,int64_t*);

extern void f_adjust_temperature();
extern void f_adjust_boxlength(double*);

extern void f_copy_atoms_init(double**);
extern void f_copy_atoms_update();
extern void f_measures_link(struct measures**);
extern void f_measures_update();
