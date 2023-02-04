#4/02/2023 By Phillip Poking Spikes

extends Area2D

export var timertime = 0

onready var spikesprite = $AnimatedSprite
onready var collisionshape = $CollisionShape2D
onready var timer = $Timer
onready var animationplayer = $AnimationPlayer
onready var soundplayer = $AudioStreamPlayer2D

var repeat = true

func _ready():
	spikesprite.frame = 3
	collisionshape.disabled = true
	spike()

#func _process(delta):
#	if !spike_out and spike_in:
#		yield(get_tree().create_timer(timertime), "timeout")
#		spike_out()
#	if spike_out and !spike_in:
#		yield(get_tree().create_timer(timertime), "timeout")
#		spike_in()
#
#This function repeats for ever
func spike():
	while repeat:
		yield(get_tree().create_timer(timertime), "timeout")
		yield(get_tree().create_timer(0.05), "timeout")
		spikesprite.frame = 2
		yield(get_tree().create_timer(0.05), "timeout")
		spikesprite.frame = 1
		yield(get_tree().create_timer(0.05), "timeout")
		spikesprite.frame = 0
		collisionshape.disabled = false
		yield(get_tree().create_timer(timertime), "timeout")
		yield(get_tree().create_timer(0.05), "timeout")
		spikesprite.frame = 1
		yield(get_tree().create_timer(0.05), "timeout")
		spikesprite.frame = 2
		yield(get_tree().create_timer(0.05), "timeout")
		spikesprite.frame = 3
		collisionshape.disabled = true
	
