extends Area2D

signal Checkpoint_reached0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass





func _on_Checkpoint_0_body_entered(body):
	if body is MainCharacter:
		LevelSavesLoaded.checkpoint1 = 0
		emit_signal("Checkpoint_reached0")
