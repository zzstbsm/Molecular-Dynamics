#!/usr/bin/python
"""
Instructions for the buttons in the menu gui
"""

import logging

logger = logging.getLogger(__name__)

def new():
	
	return
	
def open():
	
	return
	
def save():
	
	return
	
def save_as():
	
	return
	
def save():
	
	return
		
class MenuFile(tk.Menu):
	
	def __init__(self,parent):
		
		logging.init_start(self.__class__.__name__)
		super().__init__(parent)
		
		self.root = parent.root
		self.build()
		
		logging.init_end(self.__class__.__name__)
		
	def build(self):
		
		self.add_command(label = "New",
							accelerator = "Ctrl+N")
		self.add_command(label = "Open",
							accelerator = "Ctrl+O")
		self.add_command(label = "Recent")
		self.add_command(label = "Save",
							accelerator = "Ctrl+S")
		self.add_command(label = "Save as...",
							accelerator = "Ctrl+Alt+S")
		self.add_separator()
		self.add_command(label = "Exit",
							accelerator = "Alt+F4",
							command = self.root.destroy)
		self.root.bind_all("<Alt-F4>", self.root.destroy)
		# ~ self.root.bind_all("<Control-w>", self.root.destroy)

class MenuHelp(tk.Menu):
	
	def __init__(self,parent):
		
		logging.init_start(self.__class__.__name__)
		super().__init__(parent)
		
		self.root = parent.root
		self.build()
		
		logging.init_end(self.__class__.__name__)
	
	def build(self):
		
		self.add_command(label = "About")
