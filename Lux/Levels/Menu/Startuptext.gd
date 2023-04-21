extends Node2D

onready var animationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("TestTransitions")

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		animationPlayer.stop()
		get_tree().change_scene("res://Levels/Menu/MainMenu.tscn") #When image sequence finished 

func _on_AnimationPlayer_animation_finished(anim_name):
		get_tree().change_scene("res://Levels/Menu/MainMenu.tscn") #When image sequence finished 
		#Move on to the main menu
