extends CanvasLayer

var keybinding_data_file = "res://keybinding.json"

var key_dictionary = {"Right": 68, "Left": 64, "Jump": 87, "Down": 83, "Dash" : 32, "Slide" : 16777237} 

var setting_key = false

func _ready():
	load_keys()
	get_child(0).visible = false
	pause_mode = Node.PAUSE_MODE_PROCESS
	
func load_keys():
	var file = File.new()
	if(file.file_exists(keybinding_data_file)): #There is a save file already! Lets alter it
		delete_old_keys()
		file.open(keybinding_data_file, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if(typeof(data) == TYPE_DICTIONARY):
			key_dictionary = data
			setup_keys()
		else:
			printerr("corrupted data")
	else: #No existing save file? Go create a new one!
		save_keys()
		
		
func _process(delta):
	#I added checks for tree/scene as I do not want user bringin this up on main menu page or intro, etc. 
	if(Input.is_action_just_pressed("Pause") and (get_tree().current_scene.name == "Tutorial")):
		get_tree().paused = !get_tree().paused
		get_child(0).visible = get_tree().paused

func setup_keys():
	for i in key_dictionary:
		for j in get_tree().get_nodes_in_group("button_keys"):
			if(j.action_name == i):
				j.text = OS.get_scancode_string(key_dictionary[i])
			var newkey = InputEventKey.new()
			newkey.scancode = int(key_dictionary[i])
			InputMap.action_add_event(i,newkey)
			
func delete_old_keys():
	#Remove old keys
	for i in key_dictionary:
		var oldkey = InputEventKey.new()
		oldkey.scancode = int(PauseMenu.key_dictionary[i])
		InputMap.action_erase_event(i, oldkey)

func save_keys():
	var file = File.new()
	file.open(keybinding_data_file, File.WRITE)
	file.store_string(to_json(key_dictionary))
	file.close()
	print("Saved")

