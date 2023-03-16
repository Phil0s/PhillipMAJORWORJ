extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label/AnimationPlayer.play("New Anim")


func _process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene("res://Levels/Menu/MainMenu.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Levels/Menu/MainMenu.tscn")
