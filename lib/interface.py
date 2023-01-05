#!/usr/bin/python
"""
Create the gui calling the various objects
"""

import tkinter as tk
from lib.gui.menu import MainMenuBar
from lib.gui.run_parameters import run_parameters
from lib.gui.plot import plot

import logging

logger = logging.getLogger(__name__)

class Interface():
	
	def __init__(self,title):
		
		self.root = tk.Tk()
		
		# Set title
		self.root.title(title)
		
		# Set window size
		self.root.geometry("1600x800")
		
		# Build the interface
		self.build()
		
		logger.info("Interface created")
		
		self.root.mainloop()

	def build(self):
		
		# Build the menu bar
		self.root.menu = MainMenuBar(self)
		self.root.config(menu=self.root.menu)
		
		# Build list of all saved runs
		
		# Build list of all the points in the run
		
		# Build run parameters window
		self.frame_run_parameters = run_parameters(self)
		self.frame_run_parameters.grid(column=0,row=0)
		
		# Build plots window
		self.frame_plot = plot(self)
		self.frame_plot.grid(column=1,row=0)
