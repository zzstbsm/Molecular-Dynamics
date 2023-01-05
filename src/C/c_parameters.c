#include <stddef.h>
#include <stdint.h>
#include "c_parameters.h"

double *atoms;
double *copy_atoms;
double sim_time;
double *force;

struct settings run_settings;
struct measures *ptr_measure;

extern char *filename_index;
extern char *filename_measure;
extern char *filename_positions;
