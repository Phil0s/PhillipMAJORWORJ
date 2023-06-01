extends Node2D
#Created: Phillip 27/11/2022 
#About: Code for main menu 

#VERSION 
onready var version = $RichTextLabel

#Declare Variables
onready var MManimationPlayer = $AnimationPlayer
var MManimationfinished = true
onready var startbut = $VBoxContainer/PlayButton
onready var settingsbut = $VBoxContainer/SettingsButton
onready var settingspage = $Control/Popup
onready var playpage = $ControlPlay/Popup
onready var musicslider = $Control/Popup/VBoxContainer/VBoxContainer/HSlider
onready var musicslider1 = $Control/Popup/VBoxContainer/VBoxContainer/HSlider2
onready var musicslider2 = $Control/Popup/VBoxContainer/VBoxContainer/HSlider3
onready var Launchbutton = $ControlPlay/Popup/VBoxContainer2/Launch
onready var nextbut = $ControlPlay/Popup/VBoxContainer2/NextBut
onready var previousbut = $ControlPlay/Popup/VBoxContainer2/PreviousBut
onready var buttonhover = $ButtonHover
onready var buttonpressed = $ButtonPressed
# onready var sliderchange = $SliderChange
onready var exitbut = $VBoxContainer/ExitButton
onready var backfromsettings = $Control/Popup/VBoxContainer/Back
onready var backfromplay = $ControlPlay/Popup/VBoxContainer2/BackfromPlay
onready var level0 = $ControlPlay/Popup/CenterContainer/GridContainer/LvlButton
onready var level1 = $ControlPlay/Popup/CenterContainer/GridContainer/LvlButton1
onready var level2 = $ControlPlay/Popup/CenterContainer/GridContainer/LvlButton2




func _ready():
	_defaultreset()
	startbut.grab_focus()
	settingspage.visible = false
	playpage.visible = false
	version.text = "Version: " + "BETA"
	
func _defaultreset(): #Played when scene first loaded, to ensure everything starts of at the correct position and settings
	MManimationPlayer.play("Default")

func _on_ExitButton_pressed(): #Close the app
	print("Exit button pressed")
	get_tree().quit()
	
	
func _on_PlayButton_pressed(): #Open the play menu
	print("Play Button Pressed")
	if MManimationfinished:
		MManimationPlayer.play("Play")
		buttonpressed.play()
		playpage.visible = true
		level0.grab_focus()
	

func _on_SettingsButton_pressed(): #Open settings button
	if MManimationfinished:
		print("Settings Button Pressed")
		buttonpressed.play()
		MManimationPlayer.play("Settings")
		settingspage.visible = true
		musicslider.grab_focus()

func _on_AnimationPlayer_animation_finished(anim_name): #To ensure no more than one animation is playing at once
	MManimationfinished = true

func _on_Back_pressed(): #Settingsback to Main Menu
	if MManimationfinished:
		MManimationPlayer.play("SettingsBack")
		buttonpressed.play()
		settingspage.visible = false
		settingsbut.grab_focus()


func _on_BackfromPlay_pressed(): #Level menu to Main menu
	if MManimationfinished:
		buttonpressed.play()
		MManimationPlayer.play("Playback")
		playpage.visible = false
		startbut.grab_focus()

func _on_Launch_pressed():
	#Note to self: If function is said to be missing in Autoload file "LoadingScript" I found out
	#if the autoload script file does actually have the function, I need to RELOAD the autoload
	#Script in the Godot Project settings. For some reason Autoload Scripts do not update so if I
	#Continue to make changes to "LoadingScript" the autoload one thats been uploaded will not update
	#I have to manually re-add it to the autoloader
	#LoadingScript.load_scene1(self, "res://Levels/Tutorials/Tutorial.tscn")
	
	#Note everything above is currently not in use. 
	
	#Global variable containing level number is changed
	var LevelNum = str(Globalscript.levelorder)
	if Globalscript.levelorder == 0:
		get_tree().change_scene("res://Levels/Tutorials/Tutorial.tscn")
	else:
		get_tree().change_scene("res://Levels/Level/Level" + LevelNum + ".tscn")




#Styling Code for buttons
#buttonhover.play() is the code for creating that BURGH sound when pressing the button
func _on_PlayButton_focus_entered():
	buttonhover.play()


func _on_SettingsButton_focus_entered():
	buttonhover.play()


func _on_ExitButton_focus_entered():
	buttonhover.play()


func _on_ExitButton_mouse_entered():
	exitbut.grab_focus()
	buttonhover.play()


func _on_SettingsButton_mouse_entered():
	buttonhover.play()
	settingsbut.grab_focus()


func _on_PlayButton_mouse_entered():
	buttonhover.play()
	startbut.grab_focus()


func _on_Back_mouse_entered():
	backfromsettings.grab_focus()
	buttonhover.play()


func _on_Back_focus_entered():
	buttonhover.play()


func _on_HSlider_focus_entered():
	buttonhover.play()


func _on_HSlider2_focus_entered():
	buttonhover.play()


func _on_HSlider3_focus_entered():
	buttonhover.play()



func _on_BackfromPlay_focus_entered():
	buttonhover.play()


func _on_BackfromPlay_mouse_entered():
	backfromplay.grab_focus()
	buttonhover.play()


func _on_Launch_focus_entered():
	buttonhover.play()


func _on_NextBut_focus_entered():
	buttonhover.play()


func _on_NextBut_mouse_entered():
	nextbut.grab_focus()
	buttonhover.play()


func _on_PreviousBut_focus_entered():
	buttonhover.play()


func _on_PreviousBut_mouse_entered():
	previousbut.grab_focus()
	buttonhover.play()


func _on_HSlider3_mouse_entered():
	musicslider2.grab_focus()


func _on_HSlider2_mouse_entered():
	musicslider1.grab_focus()


func _on_HSlider_mouse_entered():
	musicslider.grab_focus()


func _on_Launch_mouse_entered():
	Launchbutton.grab_focus()
	buttonhover.play()
	
	



func _on_LvlButton_focus_entered():
	buttonhover.play()


func _on_LvlButton_pressed():
	get_tree().change_scene("res://Levels/Tutorials/Tutorial.tscn")

func _on_LvlButton_mouse_entered():
	level0.grab_focus()


func _on_LvlButton1_focus_entered():
	buttonhover.play()

func _on_LvlButton1_mouse_entered():
	level1.grab_focus()
