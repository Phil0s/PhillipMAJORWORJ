extends Node2D

func _ready():
	pass # Replace with function body.

func _on_GodotLogoAnimatedSprite_animation_finished():
	get_tree().change_scene("res://Levels/Menu/Startuptext.tscn") #When image sequence finished move on to next scene
