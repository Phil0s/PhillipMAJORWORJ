extends Control
#Getting the audiobus, AudioServer is global so no need to reference a specific file, etc.
#Created: Phillip 10/12/2022
#About this code is for audio settings

#Declaring Variables
var master_bus = AudioServer.get_bus_index("Master")
var audio_setting_file = "res://audiosave.txt"
onready var audio_slider = $Popup/VBoxContainer/VBoxContainer/HSlider
onready var audio_music_slider = $Popup/VBoxContainer/VBoxContainer/HSlider2
onready var audio_effects_slider = $Popup/VBoxContainer/VBoxContainer/HSlider3
onready var sliderchange = $SliderChange

var audio_master : int = 0
var audio_music : int = 0
var audio_effects : int = 0

#var audio_dictionary : int = 0
var audio_dictionary = {"audio_master": audio_master, "audio_music": audio_music, "audio_effects": audio_effects}




#AudioServer controls all the audio of Godot. Inside there are different buses kinda like categories. 
func _ready():
	var file = File.new()
	if(file.file_exists(audio_setting_file)): 
		print("There is an audio file!")
		file.open(audio_setting_file, File.READ)
		var read_dictionary = parse_json(file.get_line())
		file.close()
		var audio_value_master = int(read_dictionary["audio_master"])
		var audio_value_music = int(read_dictionary["audio_music"])
		var audio_value_effects = int(read_dictionary["audio_effects"])
		
		AudioServer.set_bus_volume_db(master_bus, audio_value_master)
		audio_slider.value = audio_value_master
		print("Assigned Master!")
		if audio_value_master == -20:
			AudioServer.set_bus_mute(master_bus, true)
		else:
			AudioServer.set_bus_mute(master_bus, false)
			
			
		AudioServer.set_bus_volume_db(1, audio_value_music)
		audio_music_slider.value = audio_value_music
		print("Assigned Music!")
		if audio_value_music == -20:
			AudioServer.set_bus_mute(1, true)
		else:
			AudioServer.set_bus_mute(1, false)

		AudioServer.set_bus_volume_db(2, audio_value_effects)
		audio_effects_slider.value = audio_value_effects
		print("Assigned Effects!")
		if audio_value_effects == -20:
			AudioServer.set_bus_mute(2, true)
		else:
			AudioServer.set_bus_mute(2, false)
			
	else:
		print_debug("No existing audio data file")

#Automantically called whenever the slider is changed
func save_audio():
	var file = File.new()
	file.open(audio_setting_file, File.WRITE)
	file.store_line(to_json(audio_dictionary))
	file.close()
	print(audio_dictionary)


#These Sliders have corresponding values to the volume of the audio buses
func _on_HSlider_value_changed(value):
	sliderchange.play()
	AudioServer.set_bus_volume_db(master_bus, value)
	audio_master = value
	audio_dictionary = {"audio_master": audio_master, "audio_music": audio_music, "audio_effects": audio_effects}
	save_audio()
	#Mute function when audio is set to 0
	if value == -20:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)

func _on_HSlider2_value_changed(value):
	sliderchange.play()
	AudioServer.set_bus_volume_db(1, value)
	audio_music = value
	audio_dictionary = {"audio_master": audio_master, "audio_music": audio_music, "audio_effects": audio_effects}
	save_audio()
	#Mute function when audio is set to 0
	if value == -20:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)


func _on_HSlider3_value_changed(value):
	sliderchange.play()
	AudioServer.set_bus_volume_db(2, value)
	audio_effects = value
	audio_dictionary = {"audio_master": audio_master, "audio_music": audio_music, "audio_effects": audio_effects}
	save_audio()
	#Mute function when audio is set to 0
	if value == -20:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)



