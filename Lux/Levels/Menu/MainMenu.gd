extends Node2D
#Created: Phillip --/11/2022 


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var MManimationPlayer = $AnimationPlayer
var MManimationfinished = true
onready var startbut = $VBoxContainer/PlayButton
onready var settingsbut = $VBoxContainer/SettingsButton
onready var settingspage = $Control/Popup
onready var playpage = $ControlPlay/Popup
onready var musicslider = $Control/Popup/VBoxContainer/VBoxContainer/HSlider
onready var Launchbutton = $ControlPlay/Popup/VBoxContainer/Launch


func _ready():
	_defaultreset()
	startbut.grab_focus()
	settingspage.visible = false
	playpage.visible = false
	
func _defaultreset(): #Played when scene first loaded, to ensure everything starts of at the correct position and settings
	MManimationPlayer.play("Default")
	$AnimatedSprite.speed_scale = 1

func _on_ExitButton_pressed(): #Close the app
	print("Exit button pressed")
	get_tree().quit()
	
	
func _on_PlayButton_pressed(): #Open level select
	print("Play Button Pressed")
	if MManimationfinished:
		MManimationPlayer.play("Play")
		$AnimatedSprite.speed_scale = 1.5
		playpage.visible = true
		print("LevelPage visible")
		Launchbutton.grab_focus()

func _on_SettingsButton_pressed(): #Open settings button
	if MManimationfinished:
		print("Settings Button Pressed")
		MManimationPlayer.play("Settings")
		$AnimatedSprite.speed_scale = 1.5
		settingspage.visible = true
		musicslider.grab_focus()

func _on_AnimationPlayer_animation_finished(anim_name): #To ensure no more than one animation is playing at once
	MManimationfinished = true

func _on_Back_pressed(): #Settingsback to Main Menu
	if MManimationfinished:
		MManimationPlayer.play("SettingsBack")
		$AnimatedSprite.speed_scale = 1
		settingspage.visible = false
		settingsbut.grab_focus()


func _on_BackfromPlay_pressed(): #Level menu to Main menu
	if MManimationfinished:
		MManimationPlayer.play("Playback")
		$AnimatedSprite.speed_scale = 1
		playpage.visible = false
		startbut.grab_focus()

func _on_Launch_pressed():
	#Note to self: If function is said to be missing in Autoload file "LoadingScript" I found out
	#if the autoload script file does actually have the function, I need to RELOAD the autoload
	#Script in the Godot Project settings. For some reason Autoload Scripts do not update so if I
	#Continue to make changes to "LoadingScript" the autoload one thats been uploaded will not update
	#I have to manually re-add it to the autoloader
	#LoadingScript.load_scene1(self, "res://Levels/Tutorials/Tutorial.tscn")
	get_tree().change_scene("res://Levels/Tutorials/Tutorial.tscn")
