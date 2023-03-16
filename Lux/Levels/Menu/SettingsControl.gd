extends Control
#Getting the audiobus, AudioServer is global so no need to reference a specific file, etc.
#Created: Phillip --/--/-- 
var master_bus = AudioServer.get_bus_index("Master")
var audio_setting_file = "res://audiosave.txt"
onready var audio_slider_master = $GridContainer3/VBoxContainer/master
onready var audio_slider_music = $GridContainer3/VBoxContainer/music
onready var audio_slider_effects = $GridContainer3/VBoxContainer/effects

var audio_master : int = 0
var audio_music : int = 0
var audio_effects : int = 0

var audio_dictionary = {"audio_master": audio_master, "audio_music": audio_music, "audio_effects": audio_effects}




func _process(delta):
	pass
#	var file = File.new()
#	if(file.file_exists(audio_setting_file)): 
#		file.open(audio_setting_file, File.READ)
#		var read_dictionary = parse_json(file.get_line())
#		file.close()
#		var audio_value_master = int(read_dictionary["audio_master"])
#		var audio_value_music = int(read_dictionary["audio_music"])
#		var audio_value_effects = int(read_dictionary["audio_effects"])
#
#
#		AudioServer.set_bus_volume_db(master_bus, audio_value_master)
#		audio_slider_master.value = audio_value_master
#		if audio_value_master == -20:
#			AudioServer.set_bus_mute(master_bus, true)
#		else:
#			AudioServer.set_bus_mute(master_bus, false)
#
#		AudioServer.set_bus_volume_db(master_bus, audio_value_music)
#		audio_slider_music.value = audio_value_music
#		if audio_value_music == -20:
#			AudioServer.set_bus_mute(1, true)
#		else:
#			AudioServer.set_bus_mute(1, false)
#
#
#		AudioServer.set_bus_volume_db(master_bus, audio_value_effects)
#		audio_slider_effects.value = audio_value_effects
#		if audio_value_effects == -20:
#			AudioServer.set_bus_mute(master_bus, true)
#		else:
#			AudioServer.set_bus_mute(master_bus, false)
#	else:
#		print("No existing audio data file")

func _on_HSlider_value_changed(value):
	#This is the main function for changing the volume value of the targed audio bus
	AudioServer.set_bus_volume_db(master_bus, value)
	audio_master = value
	audio_dictionary = {"audio_master": audio_master, "audio_music": audio_music, "audio_effects": audio_effects}
	save_audio()
	#Mute function when audio is set to 0
	if value == -20:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)


func save_audio():
	var file = File.new()
	file.open(audio_setting_file, File.WRITE)
	file.store_line(to_json(audio_dictionary))
	file.close()


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	audio_music = value
	audio_dictionary = {"audio_master": audio_master, "audio_music": audio_music, "audio_effects": audio_effects}
	save_audio()
	#Mute function when audio is set to 0
	if value == -20:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)


func _on_effects_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	audio_effects = value
	audio_dictionary = {"audio_master": audio_master, "audio_music": audio_music, "audio_effects": audio_effects}
	save_audio()
	#Mute function when audio is set to 0
	if value == -20:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
