extends Node


func _init() -> void:
	if not OS.has_feature("editor"):
		for pack in DirAccess.get_files_at(OS.get_executable_path().get_base_dir()):
			if pack.ends_with(".pck"):
				ProjectSettings.load_resource_pack(pack)
				print("Loaded resource pack: {mod}".format({"mod":pack}))
		print("\n")
	else:
		print("Editor build can't load mods\n")
