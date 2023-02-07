extends KinematicBody2D
#Credits: Rungeon's advanced platformer controlls series for all movement in this script -> Basic Movement, Dashing, Wall Jump, Wall Slide
#Created: Phillip 31/12/2022: 


class_name MainCharacter

#Particle
export(PackedScene) var foot_step
var last_step = 0
export(PackedScene) var dash_object
export var dash_speed = 1000
export var dash_length = 0.2
export var slide_length = 1

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

var continue_sliding = false

#Static Variables
var vSpeed = 0
var hSpeed = 0

var motion = Vector2.ZERO
var UP : Vector2 = Vector2(0, -1) #Negative one points upward, this is used later on to give Godot a sense of our UP direction

#Booleans
var touching_ground : bool = false # Check if we are on the ground 
var touching_wall : bool = false # Check if we are touching a wall
var is_jumping : bool = false #Check if we are currently jumping
var is_double_jumping : bool = false #Check if we are currently double jumping
var air_jump_pressed : bool = false #Check if we've pressed jump just before we land
var coyote_time : bool = false #Check if we can JUST after we leave platform
var can_double_jump : bool = false #Check if we can double jump
var is_sliding : bool = false #check if we are currently sliding
var can_slide : bool = false #are we able to slide?
var is_wall_sliding : bool = false #Are we sliding down wall?
var is_dashing : bool = false #CHeck if we are currently dashing
var can_dash : bool = true #Check if we can dash?
var dash_direction : Vector2 #Get the direction the character is currently facing


#Grabbing nodes
onready var sprite = $AnimatedSprite 
onready var ground_ray = $raycast_container/ray_ground
onready var stand_collision = $stand_collision
onready var slide_collision = $slide_collision
onready var right_ray = $raycast_container/ray_right
onready var left_ray = $raycast_container/ray_left
onready var dash_timer = $dash_timer
onready var dash_particles = $dash_particles
onready var cieling_ray = $raycast_container/ray_ceiling



#Camera Shake
#export var camera_shake_strength: float = 30.0
#export var shake_decrease_rate: float = 0
#export var noise_shake_speed: float = 1
#export var noise_shake_strength: float = 80.0
#
#
#onready var camera = $Camera2D
#onready var random = RandomNumberGenerator.new()
#onready var noise = OpenSimplexNoise.new()
#
#
#var noise_var: float = 0.0
#var shake_strength: float = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	dash_timer.connect("timeout",self,"dash_timer_timeout")
#	random.randomize()
#	noise.seed = random.randi()
#	noise.period = 2
#	Globalscript.apply_shake = false
	
#func noise_generated_offset(delta: float) -> Vector2:
#	noise_var += delta * noise_shake_speed
#	return Vector2(
#		noise.get_noise_2d(1, noise_var) * shake_strength,
#		noise.get_noise_2d(100, noise_var) * shake_strength
#	)
	
func _physics_process(delta):
#	if Globalscript.apply_shake:
#		shake_strength = 5
#		shake_strength = lerp(shake_strength, 0, shake_decrease_rate * delta)
#		camera.offset = noise_generated_offset(delta)
	#Handle dash movement
	handle_dash(delta)
	#Check if we are on the ground
	check_ground_wall_logic()
	#Check for standing or sliding
	handle_player_collision_shapes()
	#Check for and handle input/character movement
	handle_input(delta)
	#Handle Particles
#	handle_player_particles()

			
	
	#Apply the physics
	do_physics(delta)
	pass

func dash_timer_timeout():
	is_dashing = false

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
	if(Input.is_action_just_pressed("Dash") and can_dash and !touching_ground):
		is_dashing = true
		can_dash = false
		dash_direction = get_direction_from_input()
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
		if(is_on_wall()):
			is_dashing = false
	else:
		dash_particles.emitting = false
	
func check_ground_wall_logic():
	#Check for coyote time (Are we JUST leaving the platform?)
	if(touching_ground and !ground_ray.is_colliding()):
		touching_ground = false
		coyote_time = true
		#Yield pauses any code pass this, so we wait for the timer's timeout
		yield(get_tree().create_timer(0.2),"timeout")
		coyote_time = false
	#Check if we are landing on the ground (again)
	if(!touching_ground and ground_ray.is_colliding()):
		sprite.scale = Vector2(1.2,0.8) #Stretch on X, Squash on Y, create landing recoil effect
	#Check if caharacter colliding with wall via raycasts
		can_dash = true
	if(right_ray.is_colliding() or left_ray.is_colliding()):
		touching_wall = true
	else:
		touching_wall = false
	#Set touching ground to true if ground_ray is colliding again
	touching_ground = ground_ray.is_colliding()
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
#	check_sliding_logic()
	handle_movement(delta)
	handle_jumping(delta)
	
func handle_movement(var delta):
	# There was an issue where touching the wall caused us to continue slowly running towards it. This ensures upon touching war we cannot move in the x
	if(is_on_wall()):
		hSpeed = 0
		motion.x = 0
	if(Input.is_action_pressed("Right") and !is_sliding):
		if(hSpeed <-100):
			hSpeed += (deacceleration * delta)
			if(touching_ground):
				sprite.play("TURN")
		elif(hSpeed < max_horizontal_speed):
			hSpeed += (acceleration * delta)
			sprite.flip_h = false
			if(touching_ground):
				sprite.play("RUN")
		else:
			if(touching_ground):
				sprite.play("RUN")
	elif(Input.is_action_pressed("Left") and !is_sliding):
		if(hSpeed > 100):
			hSpeed -= (deacceleration * delta)
			if(touching_ground):
				sprite.play("TURN")
		elif(hSpeed > -max_horizontal_speed):
			hSpeed -= (acceleration * delta)
			sprite.flip_h = true
			if(touching_ground):
				sprite.play("RUN")
		else:
			if(touching_ground):
				sprite.play("RUN")
	else:
		if(touching_ground):
			if(!is_sliding):
				sprite.play("IDLE")
#			else: #We are sliding then
#				if(abs(hSpeed) < 0.2):
#					sprite.stop()
#					sprite.frame = 1
		hSpeed -= min(abs(hSpeed), current_friction * delta) * sign(hSpeed)
	
func handle_jumping(var delta):
	if(coyote_time and Input.is_action_just_pressed("Jump")):
		vSpeed = jump_height
		is_jumping = true
		can_double_jump = true
	if(touching_ground):
		if((Input.is_action_just_pressed("Jump") or air_jump_pressed) and !is_jumping):
			vSpeed = jump_height
			is_jumping = true
			touching_ground = false
			sprite.scale = Vector2(0.5,1.2)
	else: #Check are we in the air, is jump button being held down? If !being held down then half the jump height. This is a shorter jump for users that quickly tap the jump button
#		if(vSpeed < 0 and !Input.is_action_pressed("Jump") and !is_double_jumping):
#			vSpeed = max(vSpeed, jump_height/2)
#		if(can_double_jump and Input.is_action_just_pressed("Jump") and !coyote_time and !touching_wall):
#			vSpeed = double_jump_height
#			sprite.play("DOUBLEJUMP")
#			is_double_jumping = true
#			can_double_jump = false
		#Animation logic for jump
		if(!is_double_jumping and vSpeed < 0):
			sprite.play("JUMPUP")
		elif(!is_double_jumping and vSpeed > 0):
			sprite.play("JUMPDOWN")
		elif(is_double_jumping and sprite.frame ==2): #Where frame is last frame number of double jump animation
			is_double_jumping = false
		if(right_ray.is_colliding() and Input.is_action_just_pressed("Jump")):
			vSpeed = wall_jump_height
			hSpeed = -wall_jump_push
			sprite.flip_h = true
			can_double_jump = true
		elif(left_ray.is_colliding() and Input.is_action_just_pressed("Jump")):
			vSpeed = wall_jump_height
			hSpeed = wall_jump_push
			sprite.flip_h = false
			can_double_jump = true
			
		if(is_wall_sliding):
			sprite.play("WALLSLIDE")
			is_double_jumping = false
		#Check if we're pressing jump just before we land
		if(Input.is_action_just_pressed("Jump")):
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
		motion = move_and_slide(motion, UP) #UP is provided as the up_direction can see godot documentation
	
	#Lerp out squash and squeeze effects
	apply_squash_squeeze()

func apply_squash_squeeze():
	#Lerp provides gradual shift, towards what? Well towards our natural scale of (1,1). So any squash or squeeze effects will gradually dissapate. 
	sprite.scale.x = lerp(sprite.scale.x,1,squash_speed)
	sprite.scale.y = lerp(sprite.scale.y,1,squash_speed)

func handle_player_collision_shapes():
	if(is_sliding and slide_collision.disabled):
		stand_collision.disabled = true
		slide_collision.disabled = false
	elif(!is_sliding and stand_collision.disabled):
		stand_collision.disabled = false
		slide_collision.disabled = true
#
#func check_sliding_logic():
#	#Check if its possible to slide, are we at max speed?
#	if(abs(hSpeed) > (max_horizontal_speed -1) and touching_ground):
#		if(!is_sliding):
#			can_slide = true
#	else:
#		can_slide = false
#	#Check if we are holding down slide key
#	if(can_slide and Input.is_action_pressed("Slide")):
#		is_sliding = true
#		can_slide = false
#
#	#Checking if we're sliding but just released the slide key
#	if(is_sliding and !Input.is_action_pressed("Slide")):
#		is_sliding = false
#	#Friction and animation logic
#	if(is_sliding and touching_ground):
#		current_friction = slide_friction #Friction is reduced during slide
#		sprite.play("SLIDE")
#	else:
#		current_friction = friction #Return to normal friction
#		is_sliding = false

#func handle_player_particles():
#	if(motion.x == 0):
#		last_step = -1
#	if(sprite.animation == "RUN"):
#		if(sprite.frame == 2 or sprite.frame == 5):
#			if(last_step != sprite.frame):
#				last_step = sprite.frame
#				var footstep = foot_step.instance()
#				footstep.emitting = true
#				footstep.global_position = Vector2(global_position.x,global_position.y + 12)
#				get_parent().add_child(footstep)


