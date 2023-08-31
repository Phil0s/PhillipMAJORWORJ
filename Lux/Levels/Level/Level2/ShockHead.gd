extends KinematicBody2D
#This File Handles ToasterBot logic (Movement, Attack, Death, etc)
#Finished 26 June

#AnimatedSprite
#Dimensions 26 22

signal dead

#Health
var max_health = 100
onready var health = max_health setget _set_health
var current_health = 0
var portal_id = 0

#Declare Variables
var is_moving_right = true
var gravity = 10
var velocity = Vector2(0,0)
var speed = 10
onready var edgeray = $EdgeRay
onready var animation = $AnimationPlayer
onready var ray = $PlayerRay
onready var ray2 = $PlayerRay2
onready var audioplayer = $AudioStreamPlayer2D
onready var sprite = $AnimatedSprite
onready var damagetimer = $Timer

var playing = false
var walking = true
var colliding = false
var playerinrange = false
var active = true

#Mainline Function (runs first when file is called)
func _ready():
	$HealthBar._on_max_health_updated(max_health)
	$HealthBar._on_health_updated(health)
	animation.play("Walk")

#Called every frame
func _process(delta):	
	if(active):
		if((ray.is_colliding() and ray.get_collider() is MainCharacter) or (ray2.is_colliding() and ray2.get_collider() is MainCharacter)):
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
	if anim_name == "Death":
		active = false
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
	if(active):
		if not edgeray.is_colliding() and is_on_floor():
			is_moving_right = !is_moving_right
			scale.x = -scale.x
		if(is_on_wall()):
			is_moving_right = !is_moving_right
			scale.x = -scale.x

#Func attack and finish_attack turn on and off HitArea
func attack():
	$HitArea.monitoring = true
	$HitAreaBehind.monitoring = true
	$HitArea.monitorable = true
	$HitAreaBehind.monitorable = true
func finish_attack():
	$HitArea.monitoring = false
	$HitAreaBehind.monitoring = false
	$HitArea.monitorable = false
	$HitAreaBehind.monitorable = false


func start_walk():
	if(active):
		animation.play("Walk")

func _on_PlayerDetector_body_entered(body):
	playerinrange = true
	
func _on_PlayerDetector_body_exited(body):
	playerinrange = false

func _on_HitArea_body_entered(body):
	pass

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Death":
		sprite.playing = false
		sprite.frame = 14

func disappear():
	$AnimatedSprite.queue_free()

func _on_ToasterBotCol_body_entered(body):
	pass


func _on_ToasterBotCol_area_entered(area):
	if(active):
		if (area.is_in_group("playerattackbox")):
			damage(25)

func _on_HitAreaBehind_body_entered(body):
	pass # Replace with function body.
	
#Health Logic
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	$HealthBar._on_health_updated(health)
	current_health = health
	if health != prev_health:
		emit_signal("health_updated", health)
		if(health == 0 or health < 0):
			kill()
			
func kill():
	if(active):
		emit_signal("dead")
		$CollisionShape2D.queue_free()
		$ToasterBotCol.queue_free()
		$HealthBar.queue_free()
		active = false
		animation.stop()
		animation.play("Death")
	

func damage(amount):
	if(active):
		if damagetimer.is_stopped():
			damagetimer.start()
			_set_health(health - amount)


func _on_Timer_timeout():
	pass # Replace with function body.
