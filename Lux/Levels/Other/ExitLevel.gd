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


func _on_Area2D_body_entered(body):
	if body is MainCharacter:
		LevelSavesLoaded.data.Level[0].checkpoint = 0
		emit_signal("Checkpoint_finished")
		get_tree().change_scene("res://Levels/Menu/MainMenu.tscn")


