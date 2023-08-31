extends Area2D


# Declaring Variable
var count = 0
var entered = false
onready var label = $Label
var cooldown = false
# Called when the node enters the scene tree for the first time.
func _ready():
	count = 0

func _process(delta):
	if(entered):
		label.visible = true
		if Input.is_action_just_pressed("ghost_spawn") and !cooldown:
			play_ghost()
	if(!entered):
		label.visible = false

func play_ghost():
	var file_check = File.new()
	if(file_check.file_exists("user://ghost" + get_tree().current_scene.name + ".json")):
		var ghost = preload("res://player_ghost.tscn")
		var load_ghost = ghost.instance()
		load_ghost.global_position = self.global_position
		get_parent().call_deferred("add_child",load_ghost)
		cooldown = true
		$Timer.start()

func _on_Node2D_body_entered(body):
	if body is MainCharacter:
		entered = true


func _on_Node2D_body_exited(body):
	if body is MainCharacter:
		entered = false


func _on_Timer_timeout():
	cooldown = false