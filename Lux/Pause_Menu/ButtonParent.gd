extends Button
#Created: Phillip 3/01/23 credits to Rungeon's pause tutorial

export(String) var action_name = ""

var do_set = false

func _pressed():
	text = ""
	do_set = true

func _input(event):
	if(do_set):
		if(event is InputEventKey):
			#Remove older keys
			var newkey = InputEventKey.new()
			newkey.scancode = int(PauseMenu.key_dictionary[action_name])
			InputMap.action_erase_event(action_name, newkey)
			#Add new key
			InputMap.action_add_event(action_name, event)
			#Show it in a readable format
			text = OS.get_scancode_string(event.scancode)
			#Update key dictionary
			PauseMenu.key_dictionary[action_name] = event.scancode
			#Save dictionary to json
			PauseMenu.save_keys()
			do_set = false
