extends KinematicBody2D
#This File Handles SkeletonEnemy logic (Movement, Attack, Death, etc)

#AnimatedSprite
#Height 32px

#Declare Variables
var is_moving_right = true
var gravity = 10
var velocity = Vector2(0,0)
var speed = 32
var animdone = 1
onready var edgeray = $EdgeRay
onready var animation = $AnimatedSprite

# Mainline Function (runs first when file is called)
func _ready():
	animation.play("Walking")

#Called every frame
func _process(delta):
	if animation.animation == "Attack":
		return
	move()
	at_edge()

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

func attack():
	$HitArea.monitoring = true
	
func finish_attack():
	$HitArea.monitoring = false


func start_walk():
	animation.play("Walking")


func _on_PlayerDetector_body_entered(body):
	if body is MainCharacter:
		if animdone == 1:
			animdone = 0
			animation.play("Attack")
			yield(get_tree().create_timer(0.5), "timeout")
			attack()
			yield(get_tree().create_timer(0.1), "timeout")
			finish_attack()
			print("done")
			animation.play("Walking")


func _on_HitArea_body_entered(body):
	get_tree().reload_current_scene()


func _on_AnimatedSprite_animation_finished():
	animdone = 1
