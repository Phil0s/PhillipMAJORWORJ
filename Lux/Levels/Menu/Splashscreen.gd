extends Node2D

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("GodotLogoReveal")

func _on_GodotLogoAnimatedSprite_animation_finished():
	get_tree().change_scene("res://Levels/Menu/Startuptext.tscn") #When image sequence finished move on to next scene
