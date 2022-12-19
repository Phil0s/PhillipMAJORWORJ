extends Control
#Getting the audiobus, AudioServer is global so no need to reference a specific file, etc.
var master_bus = AudioServer.get_bus_index("Master")




func _on_HSlider_value_changed(value):
	#This is the main function for changing the volume value of the targed audio bus
	AudioServer.set_bus_volume_db(master_bus, value)

	#Mute function when audio is set to 0
	if value == -20:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
