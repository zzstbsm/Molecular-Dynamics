import struct

import os
import time as tm

import numpy as np

from mpl_toolkits import mplot3d
import matplotlib.pyplot as plt
from matplotlib import animation



# Set figure
ax = []
atoms_set = []
fig = plt.figure()
ax.append(fig.add_subplot(221,projection = '3d'))
ax.append(fig.add_subplot(222))
ax.append(fig.add_subplot(223,projection = '3d'))
ax.append(fig.add_subplot(224))

# ~ f.seek(-8*(6*n_atoms+1),2)

# Plotting the Animation

def do_animation():

	with open("data/prova.bin",'rb') as f:
		
		# ~ f.seek(0,0)	
		
		figAn = plt.figure(figsize=(16,16))
		axAn = plt.axes(projection='3d')
		
		# Discard index
		f.read(8)
		# Read number of atoms
		n_atoms = int.from_bytes(f.read(8),byteorder="little")
		# Read size of the box
		boxlength = struct.unpack("d",f.read(8))[0]
		# Read target temperature
		required_temperature = struct.unpack("d",f.read(8))[0]
		# Discard tolerance
		f.read(8)
		# Discard step
		f.read(8)
		# Discard integrator
		f.read(8)
			
		if num == 0:
			f.seek(40,0)

		axAn.clear()  # Clears the figure to update the line, point,   
					# title, and axes
					
		# Read time
		time = struct.unpack("d",f.read(8))[0]
		# Read initial atoms positions
		atoms = np.array(struct.unpack("d"*6*n_atoms,f.read(8*6*n_atoms))).reshape(n_atoms,6).transpose()
		
		# Setting Axes Limits
		axAn.scatter(atoms[0][:], atoms[1][:], atoms[2][:])
		axAn.set_title("Time: %.2f - N: %d - Length: %.2f- Temperature: %.2f" %(time,n_atoms,boxlength,np.sum(np.power(atoms[3:6][:],2))/(3*n_atoms)))
		axAn.set_xlim([0,boxlength])
		axAn.set_ylim([0,boxlength])
		axAn.set_zlim([0,boxlength])

		axAn.set_xlabel('x')
		axAn.set_ylabel('y')
		axAn.set_zlabel('z')
		
		print(num)
		if num == nFrames:
			f.seek(40,0)		
	line_ani = animation.FuncAnimation(figAn, animate_func, interval=250,   
								   frames=nFrames)
								   
	line_ani.save("animazione.mp4")

def show_refreshed():
	plt.ion()
	with open("data/prova.bin",'rb') as f:
			
		figAn = plt.figure(figsize=(16,16))
		axAn = plt.axes(projection='3d')
		# Discard index
		f.read(8)
		# Read number of atoms
		n_atoms = int.from_bytes(f.read(8),byteorder="little")
		# Read size of the box
		boxlength = struct.unpack("d",f.read(8))[0]
		# Read target temperature
		required_temperature = struct.unpack("d",f.read(8))[0]
		# Discard tolerance
		f.read(8)
		# Discard step
		f.read(8)
		# Discard integrator
		f.read(8)
		
		# Scatter plot
		while True:
			axAn.clear()  # Clears the figure to update the line, point,   
						# title, and axes
						
			# Read time
			time = struct.unpack("d",f.read(8))[0]
			# Read initial atoms positions
			atoms = np.array(struct.unpack("d"*6*n_atoms,f.read(8*6*n_atoms))).reshape(n_atoms,6).transpose()
			
			# Setting Axes Limits
			axAn.scatter(atoms[0][:], atoms[1][:], atoms[2][:])
			axAn.set_title("Time: %.2f - N: %d - Length: %.2f- Temperature: %.2f" %(time,n_atoms,boxlength,np.sum(np.power(atoms[3:6][:],2))/(3*n_atoms)))
			axAn.set_xlim([0,boxlength])
			axAn.set_ylim([0,boxlength])
			axAn.set_zlim([0,boxlength])

			axAn.set_xlabel('x')
			axAn.set_ylabel('y')
			axAn.set_zlabel('z')
			plt.pause(.5)
		plt.show()

show_refreshed()
