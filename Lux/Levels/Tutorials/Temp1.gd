extends Area2D

signal Checkpoint_reached1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _on_Checkpoint_1_body_entered(body):
	if body is MainCharacter:
		LevelSavesLoaded.checkpoint1 = 1
		emit_signal("Checkpoint_reached1")

