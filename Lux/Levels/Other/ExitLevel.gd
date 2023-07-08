extends Area2D

# Declare signals
signal Checkpoint_finished 



# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _on_Area2D_body_entered(body):
	if body is MainCharacter:
		LevelSavesLoaded.data.Level[0].checkpoint = 0
		emit_signal("Checkpoint_finished")
		get_tree().change_scene("res://Levels/Menu/MainMenu.tscn")


