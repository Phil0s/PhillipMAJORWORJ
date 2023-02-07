#Credits: Game Envdeavor "Screen SHake" 7/02/2023

extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var camera = get_parent()


var amplitude = 0
onready var tween = $Tween
onready var timer = $Timer
onready var duration_timer = $DurationTimer

var priority = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func start(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	if priority >= self.priority:
		self.priority = priority
		self.amplitude = amplitude
		duration_timer.wait_time = duration
		timer.wait_time = 1 / float(frequency)
		timer.start()
		duration_timer.start()
	
		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)

	tween.interpolate_property(camera, "offset", camera.offset, rand, timer.wait_time, TRANS, EASE)
	tween.start()
	
func _reset():
	tween.interpolate_property(camera, "offset", camera.offset, Vector2(), timer.wait_time, TRANS, EASE)
	tween.start()
	
	priority = 0
	
func _on_Timer_timeout():
	_new_shake()


func _on_DurationTimer_timeout():
	_reset()
	timer.stop()


func _on_KinematicBody2D_shake():
	start()
