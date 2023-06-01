extends Control
#Created: Phillip 2/12/2022
#About: Code for play menu

#Declaring Variables
#onready var title = $Popup/VBoxContainer/LevelsTitle
#onready var levelpicture = $Popup/TextureRect
#onready var buttonpress = $ButtonPress
#onready var dangerlevel = $Popup/DangerIcons
#onready var missiondetails = $Popup/MissionDescription
#


# Called when the node enters the scene tree for the first time.
func _ready():
#	Globalscript.levelorder = 0
	pass


#Changing details of level accordingly to level number which was changed in the main menu file
func _process(delta):
		pass
#	var tutorial_time = str(LevelTimer.tutorialrecord)
#	if Globalscript.levelorder == 0:
#		#$Popup/VBoxContainer/Level_Time.text = "Record: " + tutorial_time
#		pass
#	if Globalscript.levelorder == 1:
#		pass
#	if Globalscript.levelorder == 2:
#		pass
#	if Globalscript.levelorder == 3:
#		title.text = "Level 3"
#		dangerlevel.texture = load("res://Resources/Sprite/MenuUI/Danger2.png")
#		#$Popup/VBoxContainer/Level_Time.text = "Record: " + str(LevelTimer.level3)
#		missiondetails.bbcode_text = "[fill]Level3works blah blah blah this text also has fll property. Note to self no space infront of first word"		
#	if Globalscript.levelorder == 4:
#		title.text = "Level 4"
#		dangerlevel.texture = load("res://Resources/Sprite/MenuUI/Danger2.png")
#		#$Popup/VBoxContainer/Level_Time.text = "Record: " + str(LevelTimer.level4)
#		missiondetails.bbcode_text = "[fill]Level4 works blah blah blah this text also has fll property. Note to self no space infront of first word"		
#	if Globalscript.levelorder == 5:
#		title.text = "Level 5"
#		dangerlevel.texture = load("res://Resources/Sprite/MenuUI/Danger3.png")
#		#$Popup/VBoxContainer/Level_Time.text = "Record: " + str(LevelTimer.level5)
#		missiondetails.bbcode_text = "[fill]Level5 works blah blah blah this text also has fll property. Note to self no space infront of first word"		
#	var LevelNums = str(Globalscript.levelorder)
#	levelpicture.texture = load("res://Resources/bG/DRG" + LevelNums + ".jpg")
#	#levelpicture.texture = load("res://Resources/bG/003e219d9c6528ab23383c5eee75f960.png")

#Example list of levels goes like tuotrial, 1, 2, 3
#If user is on tutorial then going backwards should jump to 3
#If user is on 3 then going forwards should jump to 1 
#This is what the two functions below do
#func _on_PreviousBut_pressed():
#	if Globalscript.levelorder == 0:
#		Globalscript.levelorder = 5
#		buttonpress.play()
#	else: 
#		Globalscript.levelorder -= 1
#		buttonpress.play()
#func _on_NextBut_pressed():
#	if Globalscript.levelorder == 5:
#		Globalscript.levelorder = 0 
#		buttonpress.play()
#	else:
#		Globalscript.levelorder += 1
#		buttonpress.play()
