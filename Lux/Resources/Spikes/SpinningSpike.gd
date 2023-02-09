extends Node2D


onready var path = $Path2D/PathFollow2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("SpinningPath")

func _process(delta):
	$Path2D/PathFollow2D/Area2D/Sprite.rotation_degrees += 5
