extends Node2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var MManimationPlayer = $AnimationPlayer
var MManimationfinished = true
onready var startbut = $VBoxContainer/PlayButton
onready var settingspage = $Control/Popup
onready var musicslider = $Control/Popup/VBoxContainer/VBoxContainer/HSlider

func _ready():
	_defaultreset()
	startbut.grab_focus()
	settingspage.visible = false
		
func _scrollcontainer():
	pass
	
func _defaultreset():
	MManimationPlayer.play("Default")
	$AnimatedSprite.speed_scale = 1

func _on_ExitButton_pressed():
	print("Exit button pressed")
	get_tree().quit()
	
	
func _on_PlayButton_pressed():
	print("Play Button Pressed")

func _on_SettingsButton_pressed():
	if MManimationfinished:
		print("Settings Button Pressed")
		MManimationPlayer.play("Settings")
		$AnimatedSprite.speed_scale = 1.5
		settingspage.visible = true
		musicslider.grab_focus()

func _on_AnimationPlayer_animation_finished(anim_name):
	MManimationfinished = true





func _on_Back_pressed():
	if MManimationfinished:
		MManimationPlayer.play("SettingsBack")
		$AnimatedSprite.speed_scale = 1
		settingspage.visible = false
		startbut.grab_focus()
