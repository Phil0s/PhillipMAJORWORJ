#4/02/2023 By Phillip Falling Spikes

extends KinematicBody2D

var velocity = Vector2()
var gravity_down = 1
var gravity_up = -1
onready var ground_ray = $ground_ray
onready var ceiling_ray = $ceiling_ray
var at_top = false
var at_bottom = false
var at_topp = false
var at_bottomm = false
var moving = false
var collide_with_ground = false
var player_on_top = false

var body_entered = false
var body_exited = false
var reset = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	#Player underneath and spike not colliding with floor
	if body_entered and !collide_with_ground:
		#Spike has collided with floor so stop spike from going any further down
		if ground_ray.is_colliding():
			body_entered = false
			collide_with_ground = true
		#Spike has not collided with floor so keep going down
		else:
			collide_with_ground = false
			gravity_down = 200
			velocity.y += delta * gravity_down
			var motion = velocity * delta
			move_and_collide(motion)
			print("1")
	#Spike has collided with the floor, nnow it is time for it to return back up
	if collide_with_ground:
		var collision = move_and_collide(velocity * delta)
		gravity_up = -80
		velocity.y += delta * gravity_up
		var motion = velocity * delta
		move_and_collide(motion)
		if ceiling_ray.is_colliding():
			collide_with_ground = false
		print("2")


#Player has entered underneath the spike
func _on_PlayerArea2D_body_entered(body):
	if body is MainCharacter:
			print("Touched")
			body_entered = true


func _on_PlayerArea2D_body_exited(body):
	pass


#func _on_Area2D_body_entered(body):
#		if body is MainCharacter:
#			player_on_top = true
#
#
#func _on_Area2D_body_exited(body):
#	if body is MainCharacter:
#			player_on_top = false
