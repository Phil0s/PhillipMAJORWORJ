extends Area2D

signal Checkpoint_reached2

onready var animatedsprite = $AnimatedSprite
var active = false

# Called when the node enters the scene tree for the first time.
# Called every frame
# Delta is time between each frame
func _process(delta):
	if(LevelSavesLoaded.data.Level[0].checkpoint != 2):
		active = false
	if(LevelSavesLoaded.data.Level[0].checkpoint == 2):
		active = true
	checkpoint()


func checkpoint():
	if(active):
		animatedsprite.animation = "ACTIVE"
	if(!active):
		animatedsprite.animation = "INACTIVE"


# These checkpoints have an area constantly looking for another body/area entering it
#
# @param {string} body - This is the name of the body entering area
# @returns none

func _on_Checkpoint_2_body_entered(body):
	if body is MainCharacter:
		active = true
		LevelSavesLoaded.data.Level[0].checkpoint = 2
		emit_signal("Checkpoint_reached2")
