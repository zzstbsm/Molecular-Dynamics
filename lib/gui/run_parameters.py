#!/usr/bin/python
"""
Create the menu in the GUI
"""

import tkinter as tk
from tkinter import ttk

import lib.logging as logging

class run_parameters(tk.Frame):
	
	def __init__(self,master=None):
		
		logging.init_start(self.__class__.__name__)
		super().__init__(master.root)
		
		self.root = master.root
		
		# Number of atoms
		self.Label_n_atoms = ttk.Label(self,text="Number of atoms")
		self.Label_n_atoms.grid(column=0,row=0,pady=10)
		self.Entry_n_atoms = ttk.Entry(self)
		self.Entry_n_atoms.grid(column=1,row=0,pady=10)
		
		# Length of the box
		self.Label_boxlength = ttk.Label(self,text="Length of the box")
		self.Label_boxlength.grid(column=0,row=1,pady=10)
		self.Entry_boxlength = ttk.Entry(self)
		self.Entry_boxlength.grid(column=1,row=1,pady=10)
		
		# Temperature
		self.Label_temperature = ttk.Label(self,text="Required temperature")
		self.Label_temperature.grid(column=0,row=2,pady=10)
		self.Entry_temperature = ttk.Entry(self)
		self.Entry_temperature.grid(column=1,row=2,pady=10)
		
		# Tolerance
		self.Label_tolerance = ttk.Label(self,text="Measure tolerance")
		self.Label_tolerance.grid(column=0,row=3,pady=10)
		self.Entry_tolerance = ttk.Entry(self)
		self.Entry_tolerance.grid(column=1,row=3,pady=10)
		
		# Integrator
		self.Label_integrator = ttk.Label(self,text="Integrator")
		self.Label_integrator.grid(column=0,row=4,pady=10)
		integrators = ["Verlet"]
		default_integrator = tk.StringVar()
		default_integrator.set(integrators[0])
		self.Box_tolerance = ttk.Combobox(self,textvariable=default_integrator,value=integrators)
		self.Box_tolerance.grid(column=1,row=4,pady=10)
		
		# Start button
		self.Button_start = tk.Button(self,text="Start")
		self.Button_start.grid(column=1,row=5,pady=10)
		
		logging.init_end(self.__class__.__name__)
		
