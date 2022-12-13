extends Node2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var MManimationPlayer = $AnimationPlayer
var MManimationfinished = true
onready var startbut = $VBoxContainer/PlayButton


func _ready():
	startbut.grab_focus()
	
		
func _scrollcontainer():
	pass


func _on_ExitButton_pressed():
	print("Exit button pressed")
	get_tree().quit()
	
	
func _on_PlayButton_pressed():
	print("Play Button Pressed")

func _on_SettingsButton_pressed():
	print("Settings Button Pressed")


func _on_AnimationPlayer_animation_finished(anim_name):
	MManimationfinished = true



