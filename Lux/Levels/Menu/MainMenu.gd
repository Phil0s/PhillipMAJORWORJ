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
onready var exitbut = $VBoxContainer/ExitButton
onready var backfromsettings = $Control/Popup/VBoxContainer/Back
onready var backfromplay = $ControlPlay/Popup/VBoxContainer2/BackfromPlay
onready var level0 = $ControlPlay/Popup/CenterContainer/GridContainer/LvlButton
onready var level1 = $ControlPlay/Popup/CenterContainer/GridContainer/LvlButton1
onready var level2 = $ControlPlay/Popup/CenterContainer/GridContainer/LvlButton2
onready var level3 = $ControlPlay/Popup/CenterContainer/GridContainer/LvlButton3


# Called when the node enters the scene tree for the first time.
func _ready():
	_defaultreset()
	startbut.grab_focus()
	settingspage.visible = false
	playpage.visible = false
	
func _defaultreset(): 
	MManimationPlayer.play("Default")

func _on_ExitButton_pressed(): 
	print("Exit button pressed")
	get_tree().quit()
	
	
func _on_PlayButton_pressed(): 
	print("Play Button Pressed")
	if MManimationfinished:
		MManimationPlayer.play("Play")
		buttonpressed.play()
		playpage.visible = true
		level0.grab_focus()
	

func _on_SettingsButton_pressed(): 
	if MManimationfinished:
		print("Settings Button Pressed")
		buttonpressed.play()
		MManimationPlayer.play("Settings")
		settingspage.visible = true
		musicslider.grab_focus()

func _on_AnimationPlayer_animation_finished(anim_name): 
	MManimationfinished = true

func _on_Back_pressed():
	if MManimationfinished:
		MManimationPlayer.play("SettingsBack")
		buttonpressed.play()
		settingspage.visible = false
		settingsbut.grab_focus()


func _on_BackfromPlay_pressed(): 
	if MManimationfinished:
		buttonpressed.play()
		MManimationPlayer.play("Playback")
		playpage.visible = false
		startbut.grab_focus()





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




func _on_HSlider3_mouse_entered():
	musicslider2.grab_focus()


func _on_HSlider2_mouse_entered():
	musicslider1.grab_focus()


func _on_HSlider_mouse_entered():
	musicslider.grab_focus()


	



func _on_LvlButton_focus_entered():
	buttonhover.play()

func _on_LvlButton_pressed():
	buttonpressed.play()
	get_tree().change_scene("res://Levels/Tutorials/Tutorial.tscn")

func _on_LvlButton_mouse_entered():
	level0.grab_focus()


func _on_LvlButton1_focus_entered():
	buttonhover.play()

func _on_LvlButton1_mouse_entered():
	level1.grab_focus()


func _on_LvlButton2_focus_entered():
	buttonhover.play()


func _on_LvlButton2_mouse_entered():
	level2.grab_focus()


func _on_LvlButton2_pressed():
	buttonpressed.play()
	get_tree().change_scene("res://Levels/Level/Level2.tscn")




func _on_LvlButton1_pressed():
	get_tree().change_scene("res://Levels/Level/Level1.tscn")




func _on_Button_pressed():
	LevelSavesLoaded._reset(0)


func _on_Button3_pressed():
	LevelSavesLoaded._reset(2)


func _on_Button2_pressed():
	LevelSavesLoaded._reset(1)
