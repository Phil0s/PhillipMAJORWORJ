extends KinematicBody2D
#This File Handles ToasterBot logic (Movement, Attack, Death, etc)
#Finished 26 June

#AnimatedSprite
#Dimensions 26 22

#Declare Variables
var is_moving_right = true
var gravity = 10
var velocity = Vector2(0,0)
var speed = 32
onready var edgeray = $EdgeRay
onready var animation = $AnimationPlayer
onready var ray = $PlayerRay
onready var audioplayer = $AudioStreamPlayer2D

var playing = false
var walking = true
var colliding = false
var playerinrange = false
var dead = false

#Mainline Function (runs first when file is called)
func _ready():
	animation.play("Walk")

#Called every frame
func _process(delta):	
	if(ray.is_colliding() and ray.get_collider() is MainCharacter):
		colliding = true
	else:
		colliding = false
	movement()
	
#Skeleton either move or attack
func movement():
	if(colliding):
		if(playerinrange):
			if(!playing):
				walking = false
				playing = true
				animation.play("Attack")
	if(!colliding and !playing):
		move()		
		at_edge()

#Resets/changes booleans depending on conditions.
func _on_AnimationPlayer_animation_finished(anim_name):
	if(colliding and playerinrange):
		playing = false
	if( !playerinrange):
		playing = false
		start_walk()
		walking = true


#Handles movement for Skeleton
#@returns none
func move():
	if is_moving_right:
		velocity.x = speed
	if !is_moving_right:
		velocity.x = -speed
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

#Gets signal from EdgeRay 
#@returns none
func at_edge():
	if not edgeray.is_colliding() and is_on_floor():
		is_moving_right = !is_moving_right
		scale.x = -scale.x
	if(is_on_wall()):
		is_moving_right = !is_moving_right
		scale.x = -scale.x

#Func attack and finish_attack turn on and off HitArea
func attack():
	$HitArea.monitoring = true
	
func finish_attack():
	$HitArea.monitoring = false


func start_walk():
	animation.play("Walk")





func _on_PlayerDetector_body_entered(body):
	playerinrange = true
	
func _on_PlayerDetector_body_exited(body):
	playerinrange = false

func _on_HitArea_body_entered(body):
	Globalscript.dead = true
