import struct

import os

import numpy as np

from mpl_toolkits import mplot3d
import matplotlib.pyplot as plt
from matplotlib import animation

class atoms:
	
	filename = ""
	
	index = 0
	n_atoms = 0
	boxlength = 0
	temperature_required = 0
	temperature_tolerance = 0
	step = 0
	integrator = 0
	time = 0
	
	file_pointer = 0
	
	atoms = []
	
	def __init__(self,filename):
		
		self.fig = plt.figure()
		self.ax = []
		seff.filename = filename
		
		# Read file header
		with open(self.filename,'rb') as f:
			
			# Read the index
			self.index = int.from_bytes(f.read(8),byteorder="little")
			# Read number of atoms
			self.n_atoms = int.from_bytes(f.read(8),byteorder="little")
			# Read size of the box
			self.boxlength = struct.unpack("d",f.read(8))[0]
			# Read target temperature
			self.temperature_required = struct.unpack("d",f.read(8))[0]
			# Discard tolerance
			self.temperature_tolerance = struct.unpack("d",f.read(8))[0]
			# Discard step
			self.step = struct.unpack("d",f.read(8))[0]
			# Discard integrator
			self.integrator = int.from_bytes(f.read(8),byteorder="little")
			
			# Set file pointer
			file_pointer = 8*7
	
	def boltzmann(self,axis):
		
		# Boltzmann distribution of velocities
		velocities = np.sqrt(np.sum(atoms[3:6][:]*atoms[3:6][:],0))
		axis.hist(velocities,30)
		axis.grid()
	
	def read_atoms(self):
		
		with open(self.filename,"rb") as f:
		
			# Read time
			time = struct.unpack("d",f.read(8))[0]
			
			# Read initial atoms positions
			atoms = np.array(struct.unpack("d"*6*n_atoms,f.read(8*6*n_atoms))).reshape(n_atoms,6).transpose()
		
		# Set file pointer
		self.file_pointer = self.file_pointer + 8*6*self.n_atoms
	
	def scatter(axis):
		# Scatter plot
		axis.scatter(self.atoms[0][:], self.atoms[1][:], self.atoms[2][:])
		axis.set_title("Time: %.2f - N: %d - Length: %.2f" %(self.time,self.n_atoms,self.boxlength))
		axis.set_xlim([0,self.boxlength])
		axis.set_ylim([0,self.boxlength])
		axis.set_zlim([0,self.boxlength])
		
	def pbc(self,atoms,boxlength,n):
		i = 0
		while i<3:
			j = 0
			while j<n:
				if atoms[i][j] > boxlength:
					atoms[i][j] = atoms[i][j] - boxlength
				elif atoms[i][j] < 0:
					atoms[i][j] = atoms[i][j] + boxlength
				j = j + 1
			i = i + 1
		return atoms
	
	def run(self):	
	
		os.system(r'make')
		os.system(r'./molecular_dynamics --number 300 --length 20 --temperature .3 --tolerance .2 --step 2e-3')
