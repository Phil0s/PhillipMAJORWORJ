extends CanvasLayer
#Created: Phillip --/--/-- with help from Rungeon's videos
var keybinding_data_file = "res://keybinding.json"

var key_dictionary = {"Right": 68, "Left": 64, "Jump": 87, "Down": 83, "Dash" : 32, "Slide" : 16777237} 

var setting_key = false

onready var audio = $GridContainer2/VBoxContainer/Button2
onready var keybinding = $GridContainer2/VBoxContainer/Button3
onready var keybinding_page = $GridContainer
onready var paused_menu_page = $GridContainer2
onready var records_page = $GridContainer3
onready var audio_page = $Control
onready var records = $GridContainer2/VBoxContainer/Button6
onready var sprites = $Sprites

var textboxhalt = false
var second_time_pressed = false

func _ready():
	load_keys()
	get_child(0).visible = false
	keybinding_page.visible = false
	audio_page.visible = false
	records_page.visible = false
	sprites.visible = false
	pause_mode = Node.PAUSE_MODE_PROCESS
	
func load_keys():
	pass

		
		
func _process(delta):
	#I added checks for tree/scene as I do not want user bringin this up on main menu page or intro, etc. 
	var scene_name = get_tree().current_scene.name
	if(scene_name != "MainMenu") and scene_name != "Startuptext":
		if(Input.is_action_just_pressed("Pause")):
			if(!TextBox.textboxrunning):
				$GridContainer2/VBoxContainer/Button6.grab_focus()
				print("1")
				get_tree().paused = !get_tree().paused
				get_child(0).visible = get_tree().paused
				if(!get_tree().paused):
					keybinding_page.visible = false
					audio_page.visible = false
					records_page.visible = false
					sprites.visible = false
			if(TextBox.textboxrunning):
				textboxhalt = true	
	if(scene_name == "TextBox"):
		pass
	else:
		pass
				
				
func setup_keys():
	pass

			
func delete_old_keys():
	pass


func save_keys():
	pass


func _on_Button3_pressed():
	paused_menu_page.visible = false
	keybinding_page.visible = true
	$GridContainer/Back1.grab_focus()


func _on_Button2_pressed():
	paused_menu_page.visible = false
	audio_page.visible = true
	$Control/GridContainer3/VBoxContainer/master.grab_focus()


func _on_Button4_pressed():
	get_tree().reload_current_scene()
	Globalscript.levelreload = true
	get_tree().paused = false
	get_child(0).visible = false
	keybinding_page.visible = false
	audio_page.visible = false


func _on_Back1_pressed():
	$AudioStreamPlayer2D.play()
	keybinding_page.visible = false
	paused_menu_page.visible = true
	records.grab_focus()


func _on_Back2_pressed():
	audio_page.visible = false
	paused_menu_page.visible = true
	records.grab_focus()


func _on_Button5_pressed():
	get_tree().paused = false
	get_child(0).visible = false
	keybinding_page.visible = false
	audio_page.visible = false
	get_tree().change_scene("res://Levels/Menu/MainMenu.tscn")



func _on_Button6_pressed():
	paused_menu_page.visible = false
	records_page.visible = true
	sprites.visible = true
	$Sprites/AnimationPlayer.play("New Anim")
	$Sprites/AnimationPlayer2.play("New Anim")
	$Sprites/AnimationPlayer3.play("New Anim")
	$Sprites/AnimationPlayer4.play("New Anim")


func _on_Back3_pressed():
	paused_menu_page.visible = true
	records_page.visible = false
	sprites.visible = false
	records.grab_focus()
	$Sprites/AnimationPlayer.stop()
	$Sprites/AnimationPlayer2.stop()
	$Sprites/AnimationPlayer3.stop()
	$Sprites/AnimationPlayer4.stop()
	
	


func _on_Button6_mouse_entered():
	$GridContainer2/VBoxContainer/Button6.grab_focus()
	$AudioStreamPlayer2D.play()


func _on_Button2_mouse_entered():
	$GridContainer2/VBoxContainer/Button2.grab_focus()
	$AudioStreamPlayer2D.play()
	
	


func _on_Button3_mouse_entered():
	$GridContainer2/VBoxContainer/Button3.grab_focus()
	$AudioStreamPlayer2D.play()


func _on_Button4_mouse_entered():
	$GridContainer2/VBoxContainer/Button4.grab_focus()
	$AudioStreamPlayer2D.play()


func _on_Button5_mouse_entered():
	$GridContainer2/VBoxContainer/Button5.grab_focus()
	$AudioStreamPlayer2D.play()


func _on_Back3_focus_entered():
	$AudioStreamPlayer2D.play()


func _on_Back3_mouse_entered():
	$AudioStreamPlayer2D.play()
	$GridContainer3/Back3.grab_focus()


func _on_Back2_mouse_entered():
	$Control/GridContainer3/VBoxContainer/Back2.grab_focus()
	$AudioStreamPlayer2D.play()


func _on_Back2_focus_entered():
	$AudioStreamPlayer2D.play()
