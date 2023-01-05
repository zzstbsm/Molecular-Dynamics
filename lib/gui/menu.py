#!/usr/bin/python
"""
Create the menu in the GUI
"""

import tkinter as tk

import lib.logging as logging

class MainMenuBar(tk.Menu):
	
	def __init__(self,master=None):
		
		logging.init_start(self.__class__.__name__)
		super().__init__(master.root)
		
		self.root = master.root
		
		self.menu_file = MenuFile(self)
		self.menu_default_projects = MenuDefaultProjects(self)
		self.menu_help = MenuHelp(self)
		
		self.add_cascade(label = "File",
							menu = self.menu_file)
		self.add_cascade(label = "Projects",
							menu = self.menu_default_projects)
		self.add_cascade(label = "Help",
							menu = self.menu_help)
		
		logging.init_end(self.__class__.__name__)

class MenuCascade(tk.Menu):
	
	def __init__(self,parent):
		
		logging.init_start(self.__class__.__name__)
		super().__init__(parent)
		
		self.root = parent.root
		self.build()
		
		logging.init_end(self.__class__.__name__)

class MenuFile(MenuCascade):
		
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

class MenuHelp(MenuCascade):
	
	def build(self):
		
		self.add_command(label = "About")

class MenuDefaultProjects(MenuCascade):
		
	def build(self):
		
		self.add_command(label = "Van Deer Waals curve")
		self.add_command(label = "Crystal fusion")
