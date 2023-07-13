extends Area2D

# Declare signals
signal Checkpoint_finished 
var entered = false
onready var label = $Label
onready var sprite = $Sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.animation = "default"
	
func _process(delta):
	if(entered):
		label.visible = true
		LevelSavesLoaded.data.Level[0].checkpoint = 0
		emit_signal("Checkpoint_finished")
		sprite.animation = "New Anim"
	if(!entered):
		label.visible = false
		sprite.animation = "default"

func _on_Door_body_exited(body):
	if body is MainCharacter:
		entered = false


func _on_Door_body_entered(body):
	if body is MainCharacter:
		entered = true
