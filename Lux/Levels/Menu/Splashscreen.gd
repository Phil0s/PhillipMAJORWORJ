extends Node2D

func _ready():
	pass # Replace with function body.


func _on_VideoPlayer_finished():
	get_tree().change_scene("res://Levels/Menu/Startuptext.tscn") #When Video finished move on to next scene
