#!/usr/bin/python
"""
Setup logging
Setup multithreading
Start GUI
"""

import lib.logging as log
from lib.interface import Interface

if __name__ == "__main__":
	log.log_SetDebug()
	log.start()
	
	try:
		interface = Interface("Molecular Dynamics")
		log.close()
	except:
		log.stop()
