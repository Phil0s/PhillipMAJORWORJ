extends Area2D

signal Checkpoint_reached1

onready var animatedsprite = $AnimatedSprite
var active = false

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if(LevelSavesLoaded.data.Level[0].checkpoint != 1):
		active = false
	if(LevelSavesLoaded.data.Level[0].checkpoint == 1):
		active = true
	checkpoint()


func checkpoint():
	if(active):
		animatedsprite.animation = "ACTIVE"
	if(!active):
		animatedsprite.animation = "INACTIVE"





func _on_Checkpoint_1_body_entered(body):
	if body is MainCharacter:
		active = true
		LevelSavesLoaded.data.Level[0].checkpoint = 1
		emit_signal("Checkpoint_reached1")
