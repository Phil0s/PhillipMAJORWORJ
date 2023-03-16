#Created 6/02/2023 Phillip 
extends Node2D

onready var spikesprite = $Sprite
onready var area2D = $Sprite/Area2D
onready var animationplayer = $AnimationPlayer

#All commented out code are the remains of trying to get the object to rotate from side to side. 


#export var timertime = 1
#var swing_right = false
#var swing_left = false
#var repeat = true
#var rotation_right = -1.74
#var rotation_left = 1.74

# Called when the node enters the scene tree for the first time.
func _ready():
#	rotation = 0
#	swing_right = true
#	swing_left = false
#	swing()
	animationplayer.play("Swing")
	
func swing():
	#	while spikesprite.rotation_degrees != -100 and swing_right:
#		spikesprite.rotation_degrees += 10
#	swing_right = false
#	swing_left = true
#	yield(get_tree().create_timer(timertime), "timeout")
#	while spikesprite.rotation_degrees != 100 and swing_left:
#		spikesprite.rotation_degrees += 10
#	swing_left = false
#	swing_right = true
	pass
	
func _on_Area2D_body_entered(body):
	if body is MainCharacter:
		print("Smashed by swinging trap")
