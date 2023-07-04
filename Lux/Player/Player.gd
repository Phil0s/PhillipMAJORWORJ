extends KinematicBody2D
#Credits: Rungeon's advanced platformer controlls series for all movement in this script -> Basic Movement, Dashing, Wall Jump, Wall Slide
#Created: Phillip 31/12/2022: 

#Sprite Dimensions
#Width 30
#Height 38



signal health_update(health)
signal killed()
signal dash
class_name MainCharacter

#Exported Variables
export(PackedScene) var foot_step
var last_step = 0
export(PackedScene) var dash_object
export var dash_speed = 1000
export var dash_length = 0.2
export var slide_length = 1

#Health
var max_health = 100
onready var health = max_health setget _set_health

var portal_id = 0

#Movement Data for Character
export var gravity = 600
export var acceleration = 550
export var deacceleration = 550
export var friction = 1000
export var current_friction = 1000
export var max_horizontal_speed = 200
export var max_fall_speed = 350
export var jump_height = -250
export var double_jump_height = -200
export var slide_friction = 100
export var squash_speed = 0.01
export var wall_jump_height = -500
export var wall_jump_push = 400
export var max_fall_speed_wall_slide = 100
export var wall_slide_gravity = 100

#Static Variables
var vSpeed = 0
var hSpeed = 0

var motion = Vector2.ZERO
var UP : Vector2 = Vector2(0, -1) #Negative one points upward, this is used later on to give Godot a sense of our UP direction
var SNAP_DIR = Vector2.DOWN
var SNAP_LENGTH = 32.0
var SNAP_VECTOR = SNAP_DIR * SNAP_LENGTH

#Booleans
var touching_ground : bool = false 
var touching_wall : bool = false 
var is_jumping : bool = false 
var is_double_jumping : bool = false 
var air_jump_pressed : bool = false #Check if we've pressed jump just before we land
var coyote_time : bool = false #Check if we can jump JUST after we leave platform
var can_double_jump : bool = false 
var is_sliding : bool = false 
var can_slide : bool = false 
var is_wall_sliding : bool = false
var is_dashing : bool = false 
var can_dash : bool = true 
var dash_direction : Vector2 #Get the direction the character is currently facing
var continue_sliding = false #Might not be used
var animfinished = true
var notattack = true
var dead1 = false


#Grabbing nodes
onready var sprite = $AnimatedSprite 
onready var ground_ray = $raycast_container/ray_ground
onready var ground_ray2 = $raycast_container/ray_ground2
onready var ground_ray3 = $raycast_container/ray_ground3
onready var stand_collision = $stand_collision
onready var slide_collision = $slide_collision
onready var right_ray = $raycast_container/ray_right
onready var right_ray1 = $raycast_container/ray_right2
onready var left_ray = $raycast_container/ray_left
onready var left_ray1 = $raycast_container/ray_left2
onready var dash_timer = $dash_timer
onready var dash_particles = $dash_particles
onready var cieling_ray = $raycast_container/ray_ceiling
onready var right_ray3 = $raycast_container/ray_right3
onready var left_ray3 = $raycast_container/ray_left3
onready var spawn_finished = false
onready var audioplayer = $AudioStreamPlayer2D
onready var audiofinished = true
onready var landingaudioplayer = $AudioStreamPlayer2D2
onready var landingaudiofinished = true
onready var playeranimation = $PlayerAnimation
onready var hitarea = $Position2D/PlayerHitArea
onready var hitareaparent = $Position2D
onready var damagetimer = $Damage
onready var damageanim = $DamageAnimation

### Main + physics Process
# Called when the node enters the scene tree for the first time.
func _ready():	
	print(max_health)
	_set_health(max_health)
	$HealthBar._on_max_health_updated(max_health)
	dead1 = false
	spawn_finished = true
	dash_timer.connect("timeout",self,"dash_timer_timeout")
	
func _physics_process(delta):
	if(spawn_finished):
		if(!dead1):
			attack()
			handle_dash(delta)
			check_ground_wall_logic()
			handle_player_collision_shapes()
			handle_input(delta)
			do_physics(delta)
			handle_player_particles()

func attack():
	if(Input.is_action_just_pressed("Attack")):
		if(!is_wall_sliding and !can_slide and !is_jumping and notattack):
			notattack = false
			playeranimation.play("Attack")


### Player Movement	
func dash_timer_timeout():
	is_dashing = false
	sprite.material.set_shader_param("whiten", false)

func get_direction_from_input():
	var move_direction = Vector2()
	move_direction.x = -Input.get_action_strength("Left") + Input.get_action_strength("Right")
	move_direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Jump")
	move_direction = move_direction.clamped(1)
	#Dashig when no x axis movement button is pressed. Dash in currently facing direction
	if(move_direction == Vector2(0,0)):
		if(sprite.flip_h):
			move_direction.x = -1
		else:
			move_direction.x = 1

	return move_direction * dash_speed

func handle_dash(var delta):
	if(Input.is_action_just_pressed("Dash") and can_dash and !touching_ground and notattack):
		emit_signal("dash")
		is_dashing = true
		can_dash = false
		dash_direction = get_direction_from_input()
		sprite.material.set_shader_param("mix_weight", 0.7)
		sprite.material.set_shader_param("whiten", true)
		dash_timer.start(dash_length)


	if(is_dashing):
		var dash_node = dash_object.instance()
		dash_node.texture = sprite.frames.get_frame(sprite.animation, sprite.frame)
		dash_node.global_position = global_position
		dash_node.flip_h = sprite.flip_h
		get_parent().add_child(dash_node)
		dash_particles.emitting = true
		if(touching_ground):
			is_dashing = false
			sprite.material.set_shader_param("whiten", false)
		if(is_on_wall()):
			is_dashing = false
			sprite.material.set_shader_param("whiten", false)
	else:
		dash_particles.emitting = false

func check_ground_wall_logic():
	#Check for coyote time (Are we JUST leaving the platform?)
	if(touching_ground and (!ground_ray.is_colliding() and !ground_ray2.is_colliding() and !ground_ray3.is_colliding())):
		touching_ground = false
		coyote_time = true
		#Yield pauses any code pass this, so we wait for the timer's timeout
		yield(get_tree().create_timer(0.2),"timeout")
		coyote_time = false
	#Check if we are landing on the ground (again)
	if(!touching_ground and (ground_ray.is_colliding() and ground_ray2.is_colliding() and ground_ray3.is_colliding())):
		landingaudioplayer.play()
		sprite.scale = Vector2(0.62,0.58) #Stretch on X, Squash on Y, create landing recoil effect
	#Check if caharacter colliding with wall via raycasts
		can_dash = true
	if((right_ray.is_colliding() and right_ray1.is_colliding()) or (left_ray.is_colliding() and left_ray1.is_colliding()) or (right_ray3.is_colliding() and right_ray.is_colliding()) or (right_ray3.is_colliding() and right_ray1.is_colliding()) or (left_ray3.is_colliding() and left_ray.is_colliding()) or (left_ray3.is_colliding() and left_ray1.is_colliding())                                                ):
		touching_wall = true
	else:
		touching_wall = false
	#Set touching ground to true if ground_ray is colliding again
	if ground_ray.is_colliding() or ground_ray2.is_colliding() or ground_ray3.is_colliding():
		touching_ground = true
	else:
		touching_ground = false
	if(touching_ground):
		is_jumping = false
		can_double_jump = true
		motion.y = 0
		vSpeed = 0
	#Wall slide logic
	if(is_on_wall() and !touching_ground and vSpeed >0):
		if(Input.is_action_pressed("Right") or Input.is_action_pressed("Left")):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false

func handle_input(var delta):
	check_sliding_logic()
	handle_movement(delta)
	handle_jumping(delta)

func handle_movement(var delta):
	# There was an issue where touching the wall caused us to continue slowly running towards it. This ensures upon touching war we cannot move in the x
	if(is_on_wall()):
		hSpeed = 0
		motion.x = 0
	if(Input.is_action_pressed("Right") and !is_sliding):
		notattack = true
		if(hSpeed <-100):
			hSpeed += (deacceleration * delta)
			if(touching_ground):
				sprite.play("TURN")
				audioplayer.playing = false
				audiofinished = true
		elif(hSpeed < max_horizontal_speed):
			hSpeed += (acceleration * delta)
			sprite.flip_h = false
			hitareaparent.scale.x = 1
			if(touching_ground):
				sprite.play("RUN")
				if(audiofinished):
					audioplayer.stream = load("res://Resources/Music/Footsteps.mp3")
					audioplayer.playing = true
					audiofinished = false
		else:
			if(touching_ground):
				sprite.play("RUN")
				if(audiofinished):
					audioplayer.stream = load("res://Resources/Music/Footsteps.mp3")
					audioplayer.playing = true
					audiofinished = false
	elif(Input.is_action_pressed("Left") and !is_sliding):
		notattack = true
		if(hSpeed > 100):
			hSpeed -= (deacceleration * delta)
			if(touching_ground):
				sprite.play("TURN")
				audioplayer.playing = false
				audiofinished = true
		elif(hSpeed > -max_horizontal_speed):
			hSpeed -= (acceleration * delta)
			sprite.flip_h = true
			hitareaparent.scale.x = -1
			if(touching_ground):
				sprite.play("RUN")
				if(audiofinished):
					audioplayer.stream = load("res://Resources/Music/Footsteps.mp3")
					audioplayer.playing = true
					audiofinished = false
		else:
			if(touching_ground):
				sprite.play("RUN")
				if(audiofinished):
					audioplayer.stream = load("res://Resources/Music/Footsteps.mp3")
					audioplayer.playing = true
					audiofinished = false
	else:
		if(touching_ground and notattack):
			if(!is_sliding and notattack):
				sprite.play("IDLE")
				audioplayer.playing = false
				audiofinished = true
			else:
				if(abs(hSpeed) < 0.2):
					sprite.stop()
					sprite.frame = 1
		hSpeed -= min(abs(hSpeed), current_friction * delta) * sign(hSpeed)

func handle_jumping(var delta):
	if(coyote_time and Input.is_action_just_pressed("Jump")):
		notattack = true
		audioplayer.playing = false
		audiofinished = true
		vSpeed = jump_height
		is_jumping = true
		can_double_jump = true
	if(touching_ground):
		if((Input.is_action_just_pressed("Jump") or air_jump_pressed) and !is_jumping and !cieling_ray.is_colliding()):
			notattack = true
			audioplayer.playing = false
			audiofinished = true
			vSpeed = jump_height
			is_jumping = true
			touching_ground = false
			sprite.scale = Vector2(0.58,0.62) #Squash on X and strech on y this when called when we are jumping
	else: #Check are we in the air, is jump button being held down? If !being held down then half the jump height. This is a shorter jump for users that quickly tap the jump button
		if(!is_double_jumping and vSpeed < 0):
			sprite.play("JUMPUP")
		elif(!is_double_jumping and vSpeed > 0):
			sprite.play("JUMPDOWN")
		elif(is_double_jumping and sprite.frame ==2): #Where frame is last frame number of double jump animation
			is_double_jumping = false
		if((right_ray.is_colliding() and right_ray1.is_colliding()) and Input.is_action_just_pressed("Jump")):
			notattack = true
			audioplayer.playing = false
			audiofinished = true
			vSpeed = wall_jump_height
			hSpeed = -wall_jump_push
			sprite.flip_h = true
			can_double_jump = true
		elif((left_ray.is_colliding() and left_ray1.is_colliding()) and Input.is_action_just_pressed("Jump")):
			notattack = true
			audioplayer.playing = false
			audiofinished = true
			vSpeed = wall_jump_height
			hSpeed = wall_jump_push
			sprite.flip_h = false
			can_double_jump = true

		if(is_wall_sliding):
			audioplayer.playing = false
			audiofinished = true
			sprite.play("WALLSLIDE")
			is_double_jumping = false
		#Check if we're pressing jump just before we land
		if(Input.is_action_just_pressed("Jump")):
			notattack = true
			air_jump_pressed = true
			yield(get_tree().create_timer(0.2), "timeout")
			air_jump_pressed = false

func do_physics(var delta):
	#Give a little bump downward if touching the cieling
	if(is_on_ceiling()):
		motion.y = 10
		vSpeed = 10

	if(!is_wall_sliding):
		vSpeed += (gravity * delta) #Delta is the time between each frame. Like in real life were gravity accelerates per second we make it accelerate 'per frame'
		vSpeed = min(vSpeed, max_fall_speed) #Limiting how fast we can fall, will stop upon reaching var max_fall_speed
	else:
		vSpeed += (wall_slide_gravity * delta)
		vSpeed = min(vSpeed, max_fall_speed_wall_slide)
	#Update motion
	motion.y = vSpeed
	motion.x = hSpeed


	if(is_dashing):
		#If we are dashing use dashing movement
		motion = move_and_slide(dash_direction, UP)
		vSpeed = 0
		hSpeed = 0
	else:
		#Apply motion to move and slide for normal motion
		motion.y = move_and_slide(motion, UP).y#UP is provided as the up_direction can see godot documentation

	#Lerp out squash and squeeze effects
	apply_squash_squeeze()

func apply_squash_squeeze():
	#Lerp provides gradual shift, towards what? Well towards our natural scale of (1,1). So any squash or squeeze effects will gradually dissapate. 
	sprite.scale.x = lerp(sprite.scale.x,0.6,squash_speed)
	sprite.scale.y = lerp(sprite.scale.y,0.6,squash_speed)

func handle_player_collision_shapes():
	if(is_sliding and slide_collision.disabled):
		stand_collision.disabled = true
		slide_collision.disabled = false
	elif(!is_sliding and stand_collision.disabled):
		stand_collision.disabled = false
		slide_collision.disabled = true

func check_sliding_logic():
	#Can only slide at max x speed
	if(abs(hSpeed) > (max_horizontal_speed -1) and touching_ground):
		if(!is_sliding):
			can_slide = true
	else:
		can_slide = false
	#just_pressed = tap, action_pressed = holding down	
	if(can_slide and Input.is_action_just_pressed("Slide")):
		notattack = true
		is_sliding = true
		can_slide = false
	if(is_sliding and motion.x == 0 and !cieling_ray.is_colliding()):
		is_sliding = false
#	Use this for action_pressed	
#	if(is_sliding and !Input.is_action_pressed("Slide")):
#		is_sliding = false
	if(is_sliding and touching_ground and !cieling_ray.is_colliding()):
		current_friction = slide_friction 
		audioplayer.playing = false
		audiofinished = true
		sprite.play("SLIDE")
	elif(is_sliding and touching_ground and cieling_ray.is_colliding()):
		print("here")
		current_friction = -2
		sprite.play("SLIDE")
	else:
		current_friction = friction #friction = normal friction
		is_sliding = false


#Footstep particles
func handle_player_particles():
	if(motion.x == 0):
		last_step = -1
	if(sprite.animation == "RUN"):
		if(sprite.frame == 1 or sprite.frame == 6):
			if(last_step != sprite.frame):
				last_step = sprite.frame
				var footstep = foot_step.instance()
				footstep.emitting = true
				footstep.global_position = Vector2(global_position.x,global_position.y + 12)
				get_parent().add_child(footstep)

func _on_AudioStreamPlayer2D_finished():
	audiofinished = true

func _on_AudioStreamPlayer2D2_finished():
	landingaudiofinished = true

func hitarea_show():
	hitarea.monitorable = true
	hitarea.monitoring = true
func hitarea_hide():
	hitarea.monitorable = false
	hitarea.monitoring = false


### Enemy + Environment + Obstacles
func _on_hitbox_area_area_entered(area):
	if(area.is_in_group("portal")):
		do_teleport(area)
	if(area.is_in_group("trap")):
		damage(25)

func do_teleport(area):
	for portal in get_tree().get_nodes_in_group("portal"):
		if(portal != area): #Not the same portal we just went through
			if(portal.id == area.id): #Look for the second "pair" portal with same ID
				if(!portal.lock_portal):
					area.do_lock()
					global_position = portal.global_position

func _on_PlayerAnimation_animation_finished(anim_name):
	if anim_name == "Attack":
		notattack = true
	if anim_name == "Dead":
		get_tree().reload_current_scene()

func _on_hitbox_area_body_entered(body):
	if(body.is_in_group("enemy")):
		damage(25)
			



#Health Logic
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	$HealthBar._on_health_updated(health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			
func kill():
	if(!dead1):
		dead1 = true
		sprite.playing = false
		sprite.stop()
		playeranimation.play("Dead")
	

func damage(amount):
	if damagetimer.is_stopped():
		damagetimer.start()
		_set_health(health - amount)
		damageanim.play("Damage")
		damageanim.play("Flash")


func _on_Damage_timeout():
	damageanim.play("Norm")
