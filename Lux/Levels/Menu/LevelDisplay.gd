extends Control

onready var title = $Popup/VBoxContainer/LevelsTitle
onready var levelpicture = $Popup/VBoxContainer/TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Globalscript.levelorder = 0

func _process(delta):
	var tutorial_time = str(LevelTimer.tutorialrecord)
	if Globalscript.levelorder == 0:
		$Popup/VBoxContainer/Level_Time.text = "Record: " + tutorial_time
		title.text = "Tutorial"
	if Globalscript.levelorder == 1:
		title.text = "Level 1"
		$Popup/VBoxContainer/Level_Time.text = "Record: " + str(LevelTimer.level1)
	if Globalscript.levelorder == 2:
		title.text = "Level 2"
		$Popup/VBoxContainer/Level_Time.text = "Record: " + str(LevelTimer.level2)
	if Globalscript.levelorder == 3:
		title.text = "Level 3"
		$Popup/VBoxContainer/Level_Time.text = "Record: " + str(LevelTimer.level3)
	if Globalscript.levelorder == 4:
		title.text = "Level 4"
		$Popup/VBoxContainer/Level_Time.text = "Record: " + str(LevelTimer.level4)
	if Globalscript.levelorder == 5:
		title.text = "Level 5"
		$Popup/VBoxContainer/Level_Time.text = "Record: " + str(LevelTimer.level5)
	var LevelNums = str(Globalscript.levelorder)
	levelpicture.texture = load("res://icon" + LevelNums + ".png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PreviousBut_pressed():
	if Globalscript.levelorder == 0:
		Globalscript.levelorder = 5
	else: 
		Globalscript.levelorder -= 1
func _on_NextBut_pressed():
	if Globalscript.levelorder == 5:
		Globalscript.levelorder = 0 
	else:
		Globalscript.levelorder += 1
