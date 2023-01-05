#!/usr/bin/python
"""
Setup the logger
"""

import sys
import traceback
import logging

logger = logging.getLogger(__name__)

def log_SetDebug():
	logging.basicConfig(format="[%(asctime)s] %(levelname)s: %(message)s",
						encoding="utf-8", 
						handlers=[
								logging.FileHandler("LOG.log"),
								logging.StreamHandler(sys.stdout)
								],
						level=logging.INFO)

def start():
	logger.info("Open program")

def close():
	logger.info("Close program")

def stop():
	logger.error("Program crashed, error")
	print(traceback.format_exc())

def init_start(class_name):
	logger.info("Start initialization %s" %class_name)

def init_end(class_name):
	logger.info("End initialization %s" %class_name)
