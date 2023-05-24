extends KinematicBody2D


var direction = Vector2.RIGHT
var velocity = Vector2.ZERO
var active = true

onready var raycastright = $Position2D/Raycastrightfloor
onready var raycastleft = $Position2D/Raycastleftfloor
onready var sprite = $Position2D/AnimatedSprite
onready var animationplayer = $AnimationPlayer
onready var position2D = $Position2D

func _ready():
	active = true
	sprite.playing = true
	animationplayer.play("Walking")

func _physics_process(delta):
	if(active):
		movement()
		if direction.x > 0:
			position2D.scale.x = 1
		if direction.x < 0:
			position2D.scale.x = -1

func movement():
	var found_wall = is_on_wall()
	
	var found_edge = not raycastright.is_colliding() or not raycastleft.is_colliding()
	
	if found_wall or found_edge:
		direction *= -1
	
	velocity = direction * 25
	move_and_slide(velocity, Vector2.UP)
		

func _on_WalkingEnemy_body_entered(body):
	if(active):
		if body is MainCharacter:
			animationplayer.play("Death")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		active = false


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Death":
		sprite.playing = false
		sprite.frame = 14
