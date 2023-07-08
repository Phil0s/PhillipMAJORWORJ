extends Area2D

signal Checkpoint1_reached0

onready var animatedsprite = $AnimatedSprite
var active = false

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if(LevelSavesLoaded.data.Level[1].checkpoint != 0):
		active = false
	if(LevelSavesLoaded.data.Level[1].checkpoint == 0):
		active = true
	checkpoint()


func checkpoint():
	if(active):
		animatedsprite.animation = "ACTIVE"
	if(!active):
		animatedsprite.animation = "INACTIVE"

func _on_Checkpoint_0_body_entered(body):
	if body is MainCharacter:
		active = true
		LevelSavesLoaded.data.Level[1].checkpoint = 0
		emit_signal("Checkpoint1_reached0")
