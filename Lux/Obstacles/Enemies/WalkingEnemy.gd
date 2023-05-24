extends KinematicBody2D

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

onready var raycastright = $Raycastrightfloor
onready var raycastleft = $Raycastleftfloor
onready var sprite = $AnimatedSprite


func _physics_process(delta):
	movement()

func movement():
	var found_wall = is_on_wall()
	
	var found_edge = not raycastright.is_colliding() or not raycastleft.is_colliding()
	
	if found_wall or found_edge:
		direction *= -1
	
	velocity = direction * 25
	move_and_slide(velocity, Vector2.UP)
	

	

