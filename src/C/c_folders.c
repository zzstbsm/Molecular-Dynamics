#include <stdio.h>
#include <sys/stat.h>

int folder_check(char *folder){
	
    struct stat sb;
    
    // Folder exists
    if (stat(folder,&sb) == 0
		&&
		S_ISDIR(sb.st_mode)) {
		return !0;	
	}
	// Folder not existing
	else {
		return 0;
	}
    
}
int folder_mkdir(char *folder){
	
	if (mkdir(folder, S_IRWXU | S_IRWXG | S_IRWXO) == -1){
		return 0;
	}
	else {
		return !0;
	}
	
}

int folder_read_index(){
	return 0;
}
