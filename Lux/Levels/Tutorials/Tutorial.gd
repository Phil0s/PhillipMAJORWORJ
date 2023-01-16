extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelTimer.timer_on = true
	LevelTimer.time = 0
	LevelTimer.final_time = 0
