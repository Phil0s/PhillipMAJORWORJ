#extends KinematicBody2D
#
#const UP = Vector2.UP
#
#export var speed = 200
#export var jump_strength = 500
#export var maximum_jumps = 2
#export var double_jump_strength = 300
#export var gravity = 300
#
#var jumps_made = 0
#var velocity = Vector2.ZERO
#
#func _physics_process(delta): 
#
#
#	#Checking the direction of movement
#	var horizontal_direction = (
#		Input.get_action_strength("Right") - Input.get_action_strength("Left")
#	)
#
#	if horizontal.x == 0:
#		character_decelerate()
#		$CharacterSprite.play("Idle")
#	else:
#		character_acceleration(input.x)
#		$CharacterSprite.play("Run")
#		if input.x > 0: 
#			$CharacterSprite.flip_h = false
#		elif input.x < 0:
#			$CharacterSprite.flip_h = true
#
#
#	velocity.x = horizontal_direction * speed
#	velocity.y += gravity * delta 
#
#
#	#Stored Variables to check character status
#	var is_falling = velocity.y > 0 and not is_on_floor()
#	var is_jumping = Input.is_action_just_pressed("Jump") and is_on_floor()
#	var is_double_jumping = Input.is_action_just_released("Jump") and is_falling
#	var is_jump_cancelled = Input.is_action_just_released("Jump") and velocity.y < 0
#	var is_idle = is_on_floor() and is_zero_approx(velocity.x)
#	var is_running = is_on_floor() and not is_zero_approx(velocity.x)
#
#	#When Jumping
#	if is_jumping:
#		jumps_made += 1
#		velocity.y = -jump_strength
#	elif is_double_jumping:
#		jumps_made += 1
#		if jumps_made <= maximum_jumps:
#			velocity.y = -double_jump_strength
#	elif is_jump_cancelled:
#		velocity.y = 0
#	elif is_idle or is_running:
#		jumps_made = 0
#
#	#Where the movement is processed and occurs
#	velocity = move_and_slide(velocity, UP)
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
#
#extends KinematicBody2D
##Holding Ctrl and clicking KinematicBody2D ^ will give definition of functions being used
##Created: Phillip --/-- - 11/22 Half me and Half heartbeast and one quarter Rungeon's dash which has been transfered to revamped player
#class_name MainCharacter
#
#export(PackedScene) var foot_step
#var last_step = 0
#
#var animation_finished = true
#
#
##Data movement references
#export(Resource) var movementData
#
##Movement + Jumping
#var motion = Vector2.ZERO
#var doublejump = 1
#var lighton = true
#var jumpbuffer = false
#var coyotejump = false
#var not_on_floor = false
#var starting_jump = false
#
#onready var jumpcooldown = $Jumpcooldown
#onready var coyotejumptimer = $Coyotejumptimer
#
##Booleans
#onready var ground_ray = $Ground_Ray
#var on_the_floor = false
#
##Dash
#onready var dash_timer = $dash_timer
#onready var dash_particles = $dash_particle
#onready var dash_warning = $Dash_Warning
#onready var dash_amount = 1
#export(PackedScene) var dash_object
#export var dash_speed = 1000
#export var dash_length = 0.2
#var is_dashing = false
#var can_dash = true
#var dash_direction : Vector2
#
#
#
#func _ready():
#	if !lighton:
#		$Light2D.enabled = false
#	else:
#		$Light2D.enabled = true
#
#	dash_timer.connect("timeout", self, "dash_timer_timeout")
#
#
#
##function checked every frame "delta".
#func _physics_process(delta):
#	character_gravity()
#
#	#Checking if on the ground
#	is_on_ground()
#	#Dash
#	handle_dash(delta)
#	out_of_dash()
#	#Particles
#	handle_foot_particles()
#
#	var input = Vector2.ZERO
#	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
#
#	if input.x == 0:
#		character_decelerate()
#		if input.x == 0 and !starting_jump:
#			$AnimatedSprite.play("Idle")
#		if input.x == 0 and starting_jump:
#			$AnimatedSprite.play("Airtime")
#	else:
#		#Change to Running Animation
#		character_acceleration(input.x)
#		if on_the_floor and !starting_jump:
#			$AnimatedSprite.play("Run")
#		if !on_the_floor and starting_jump:
#			$AnimatedSprite.play("Airtime")
#		if input.x > 0: 
#			$AnimatedSprite.flip_h = false
#		elif input.x < 0:
#			$AnimatedSprite.flip_h = true
#
#	#JUMP 
#	#Detects when colliding.
#	if is_on_floor():
#		doublejump = movementData.doublejumpamount
#	jumping()
#
#
#	#Making the actual sprite move
#	#move_and_slide(horiontal and vertical motion), this function moves the sprite
#	#along the vectors x and y (no z since 2D).
#	#also returns the final calculated motion, can be used?
#	#Motion = move_and_slide to make sure we reset our motion after falling, else the character would continue
#	#its very fast gravity motion, the values move_and_slide return a velocity after calculation, so when it hits the floor it will
#	#return to zero.
#
#	var in_air = not is_on_floor()
#	var was_onfloor = is_on_floor()
#
#	#motion = move_and_slide(motion, Vector2.UP) For Original Movement without dash
#	if(is_dashing):
#		motion = move_and_slide(dash_direction, Vector2.UP)
#	else:
#		motion = move_and_slide(motion, Vector2.UP)
#
#	var on_land = is_on_floor() and in_air
#	if on_land:
#		$AnimatedSprite.animation = "Idle"
#		$AnimatedSprite.frame = 1
#
#	var just_leftfloor = not is_on_floor() and was_onfloor
#	if just_leftfloor and motion.y >= 0:
#		coyotejump = true
#		coyotejumptimer.start()
#
##Functions outside of process, some independent some called inside process
#
#func character_gravity():
#	motion.y += movementData.gravity
#	#Stopping player from falling super super quickly, limiting their fall speed
#	if motion.y > movementData.maxfallspeed:
#		motion.y = movementData.maxfallspeed
#
#func jumping():
#	if is_on_floor() or coyotejump:
#		#Using action_just_pressed to ensure cannot infinite jump
#		if Input.is_action_just_pressed("Jump") or jumpbuffer:
#			starting_jump = true
#			motion.y = movementData.jump
#			jumpbuffer = false
#	else: #When in the air
#		if Input.is_action_just_released("Jump") and motion.y < -50:
#			motion.y = -50
#		if Input.is_action_just_pressed("Jump") and doublejump > 0 and not coyotejump:
#			starting_jump = true
#			motion.y = movementData.jump
#			doublejump = 0
#			print("DoubleJumped!")
#		if Input.is_action_just_pressed("Jump"):
#			jumpbuffer = true
#			jumpcooldown.start()
#
##For slowing the character down, lowering acceleration will take longer to deaccelerate
##creating effects such as walking on ice, etc. 
#func character_decelerate():
#	motion.x = move_toward(motion.x, 0, movementData.acceleration)
#
##For accelerating character, increase acceleration to make character faster
##increase maxspeed to make character's fastest speed faster.
#func character_acceleration(inputXamount):
#	#Move_toward = (initial velocity, target velocity, how much increment)
#	motion.x = move_toward(motion.x, movementData.maxspeed * inputXamount, movementData.acceleration)
#
#
#func _on_Jumpcooldown_timeout():
#	jumpbuffer = false
#
##If user does not press jump within coyotejumptimer they cannot do a coyote jump. 
#func _on_Coyotejumptimer_timeout():
#	coyotejump = false
#
#func get_direction_from_input():
#	#Similar to the left and right for normal movemenet, subtracting the two values of opposite controls will find where the character
#	#Is facing and heading. 
#	var move_dir = Vector2()
#	move_dir.x = -Input.get_action_strength("Left") + Input.get_action_strength("Right")
#	move_dir.y = Input.get_action_strength("Down") - Input.get_action_strength("Jump")
#	move_dir = move_dir.clamped(1)
#	if (move_dir == Vector2(0,0)):
#		if($AnimatedSprite.flip_h):
#			move_dir.x = -1
#		else:
#			move_dir.x = 1
#	return move_dir * dash_speed
#
#func handle_dash(var delta):
#	#If dash button pressed can user is in a can_dash state and is up in the air and has dash remaining- dash
#	if(Input.is_action_just_pressed("Dash") and can_dash and !on_the_floor and dash_amount > 0):
#		is_dashing = true
#		can_dash = false
#		dash_direction = get_direction_from_input()
#		dash_timer.start(dash_length)
#		dash_amount -= 1
#		print("dashed")
#	if(is_dashing):
#		#Get the dash_object which has the fading away code
#		var dash_node = dash_object.instance()
#		#Make it's texture the same as whatever the character sprite is showing
#		dash_node.texture = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame)
#		dash_node.global_position = global_position
#		dash_node.flip_h = $AnimatedSprite.flip_h
#		get_parent().add_child(dash_node)
#		#Start emitting the particles
#		dash_particles.emitting = true
#
#		if(on_the_floor):
#			is_dashing = false
#		#If on wall function
#	else:
#		dash_particles.emitting = false
#
#func dash_timer_timeout():
#	is_dashing = false
#
#func is_on_ground():
#	#Update the raycast then get the returned value
#	ground_ray.force_raycast_update()
#	on_the_floor = ground_ray.is_colliding()
#	#If is back on the ground then change can_dash back to true again
#	can_dash = true
#	if on_the_floor:
#		starting_jump = false
#
#
#func out_of_dash():
#	#Check if dash amount is 0 which reveals the label "Out of Dash" More work to be done on this
#	if(Input.is_action_just_pressed("Dash")):
#		if dash_amount <= 0:
#			dash_warning.visible = true
#		elif dash_amount >0:
#			dash_warning.visible = false
#
#
#func _on_Dash_Orb_dashorb_collected(value):
#	dash_amount += value
#	print("Value Increased")
#
#
#func handle_foot_particles():
#	if(motion.x ==0):
#		last_step = -1
#	if($AnimatedSprite.animation == "Run") and on_the_floor:
#		if($AnimatedSprite.frame == 2 or $AnimatedSprite.frame == 5):
#			last_step = $AnimatedSprite.frame
#			var footstep = foot_step.instance()
#			footstep.emitting = true
#			footstep.global_position = Vector2(global_position.x,global_position.y + 15)
#			get_parent().add_child(footstep)
#	if Input.is_action_just_pressed("Jump") and doublejump > 0 and not coyotejump:
#			var footstep = foot_step.instance()
#			footstep.emitting = true
#			footstep.global_position = Vector2(global_position.x,global_position.y + 0)
#			get_parent().add_child(footstep)
##func jump_animation():
#	#if not_on_floor and !is_dashing and Input.is_action_just_pressed("Jump"):
#			#$AnimatedSprite.play("Jumping")
#
#
#func _on_AnimatedSprite_animation_finished():
#	if $AnimatedSprite.animation == "Jumping":
#		animation_finished = true
#		print("Jumping finished")
#
