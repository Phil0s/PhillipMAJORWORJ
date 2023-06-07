extends Area2D

signal Checkpoint_finished 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass






func _on_Exit_body_entered(body):
	if body is MainCharacter:
		LevelSavesLoaded.data.Level[1].checkpoint = 0
		emit_signal("Checkpoint_finished")
		
#		LevelTimer.timer_on = false
#		if LevelTimer.tutorial_first_time == 0:
#			LevelTimer.tutorial_first_time = 1
#			LevelTimer.tutorialrecord = LevelTimer.final_time
#			print(LevelTimer.tutorialrecord)
#		if LevelTimer.tutorial_first_time == 1:
#			if LevelTimer.final_time > LevelTimer.tutorialrecord:
#				print("Slower time not recorded")
#			elif LevelTimer.final_time < LevelTimer.tutorialrecord:
#				LevelTimer.tutorialrecord = LevelTimer.final_time
#				print(LevelTimer.tutorialrecord)
		get_tree().change_scene("res://Levels/Level/Level2.tscn")