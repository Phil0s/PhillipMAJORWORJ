extends Area2D

export var timertime = 0

onready var spikesprite = $AnimatedSprite
onready var collisionshape = $CollisionShape2D
onready var timer = $Timer
onready var animationplayer = $AnimationPlayer


func _ready():
	spikesprite.frame = 3
	spike()
func spike():
	yield(get_tree().create_timer(0.1), "timeout")
	spikesprite
