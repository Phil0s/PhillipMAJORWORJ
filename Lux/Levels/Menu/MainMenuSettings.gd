extends Control
#Getting the audiobus, AudioServer is global so no need to reference a specific file, etc.
#Created: Phillip -//-//- 
var master_bus = AudioServer.get_bus_index("Master")
var audio_setting_file = "res://audiosave.txt"
onready var audio_slider = $Popup/VBoxContainer/VBoxContainer/HSlider

var audio_dictionary : int = 0

func _ready():
	var file = File.new()
	if(file.file_exists(audio_setting_file)): 
		print("There is an audio file!")
		file.open(audio_setting_file, File.READ)
		var audio_value = int(file.get_line())
		file.close()
		AudioServer.set_bus_volume_db(master_bus, audio_value)
		audio_slider.value = audio_value
		print("Assigned!")
		if audio_value == -20:
			AudioServer.set_bus_mute(master_bus, true)
		else:
			AudioServer.set_bus_mute(master_bus, false)
	else:
		print("No existing audio data file")
	

func save_audio():
	var file = File.new()
	file.open(audio_setting_file, File.WRITE)
	file.store_line(str(audio_dictionary))
	file.close()


func _on_HSlider_value_changed(value):
		#This is the main function for changing the volume value of the targed audio bus
	AudioServer.set_bus_volume_db(master_bus, value)
	audio_dictionary = value
	print(audio_dictionary)
	save_audio()
	#Mute function when audio is set to 0
	if value == -20:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
