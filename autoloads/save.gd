## Manages saving game values into a file in the user data folder
extends Node


signal file_saved(created: bool) ## Emitted when a file is saved, or created
signal file_loaded(upgraded: bool) ## Emitted when a file is loaded, or upgraded


const _path: String= "user://save.dat" ## Path to the save file
const _my_version: int= 0 ## Save file's version to be checked so it can be upgraded

## Creates a new save file, emits [code]file_saved[/code].
## [br][br][b]Note:[/b] If there's already a file at [code]path[/code], this function will overwrite it.
func new_file(path: String= _path) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_8(_my_version) # Store version
	file.store_32(0) # Store high score
	file.close()
	file_saved.emit(true)
	print("New file created!")

## Saves the game to [code]path[/code], also emits [code]file_saved[/code].
## [br][br][b]Note:[/b] If there's already a file at [code]path[/code], this function will overwrite it.
func save_file(path: String= _path) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_8(_my_version) # Store version
	file.store_32(Session.hiscore) # Store high score
	file.close()
	file_saved.emit(false)
	print("File saved!")

## Loads a save file, emits [code]file_loaded[/code] if loaded successfully.
## [br][br][b]Warning:[/b] This function calls [code]new_file[/code] if we're [i](somehow)[/i] loading a save file with a different tag, or fails to upgrade a file from another version.
func load_file(path: String= _path) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file != null:
		if file.get_error() != OK:
			push_error(error_string(file.get_error()))
			new_file()
			return
		var file_version: int= file.get_8()
		if file_version == _my_version: # Check the version
			Session.hiscore = file.get_32() # Set the highscore
			file_loaded.emit(false)
			print("File loaded!")
		else:
			print("File's version is ", file_version, "\nCurrent version is ",_my_version)
			file.close()
			if upgrade_file(path):
				file_loaded.emit(true)
				print("Upgraded file!")
			else:
				push_error("Could not upgrade file of version ", file_version, " to version ", _my_version)
				new_file()
	else:
		new_file()
		return
	file.close()

## Upgrades the current savefile to [code]_my_version[/code], returns [code]true[/code] if successful.
func upgrade_file(path: String= _path) -> bool:
	var file = FileAccess.open(path, FileAccess.READ)
	var _file_version: int= file.get_8()
	match _file_version:
		0:
			Session.hiscore = file.get_32()
			save_file()
			return true
	return false


func _ready():
	load_file()
