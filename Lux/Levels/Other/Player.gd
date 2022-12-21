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


extends KinematicBody2D
#Holding Ctrl and clicking KinematicBody2D ^ will give definition of functions being used
class_name MainCharacter

export(Resource) var movementData

var motion = Vector2.ZERO
var doublejump = 1
var lighton = true
var jumpbuffer = false
var coyotejump = false


onready var jumpcooldown = $Jumpcooldown
onready var coyotejumptimer = $Coyotejumptimer


func _ready():
	if !lighton:
		$Light2D.enabled = false
	else:
		$Light2D.enabled = true
	

#function checked every frame "delta".
func _physics_process(delta):
	
	character_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	
	
	
	if input.x == 0:
		character_decelerate()
		$AnimatedSprite.play("Idle")
	else:
		#Change to Running Animation
		character_acceleration(input.x)
		$AnimatedSprite.play("Idle")
		if input.x > 0: 
			$AnimatedSprite.flip_h = false
		elif input.x < 0:
			$AnimatedSprite.flip_h = true


	#JUMP 
	#Detects when colliding.
	if is_on_floor():
		doublejump = movementData.doublejumpamount
	jumping()
	
	
	#Making the actual sprite move
	#move_and_slide(horiontal and vertical motion), this function moves the sprite
	#along the vectors x and y (no z since 2D).
	#also returns the final calculated motion, can be used?
	#Motion = move_and_slide to make sure we reset our motion after falling, else the character would continue
	#its very fast gravity motion, the values move_and_slide return a velocity after calculation, so when it hits the floor it will
	#return to zero.
	
	var in_air = not is_on_floor()
	var was_onfloor = is_on_floor()
	
	motion = move_and_slide(motion, Vector2.UP)
	
	var on_land = is_on_floor() and in_air
	if on_land:
		$AnimatedSprite.animation = "Idle"
		$AnimatedSprite.frame = 1
		
	var just_leftfloor = not is_on_floor() and was_onfloor
	if just_leftfloor and motion.y >= 0:
		coyotejump = true
		coyotejumptimer.start()

#Functions outside of process, some independent some called inside process

func character_gravity():
	motion.y += movementData.gravity
	#Stopping player from falling super super quickly, limiting their fall speed
	if motion.y > movementData.maxfallspeed:
		motion.y = movementData.maxfallspeed
	
func jumping():
	if is_on_floor() or coyotejump:
		#Using action_just_pressed to ensure cannot infinite jump
		if Input.is_action_just_pressed("Jump") or jumpbuffer:
			motion.y = movementData.jump
			jumpbuffer = false
	else: #When in the air
		$AnimatedSprite.animation = "Jumping"
		if Input.is_action_just_released("Jump") and motion.y < -50:
			motion.y = -50
		if Input.is_action_just_pressed("Jump") and doublejump > 0 and not coyotejump:
			motion.y = movementData.jump
			doublejump = 0
			print("DoubleJumped!")
		if Input.is_action_just_pressed("Jump"):
			jumpbuffer = true
			jumpcooldown.start()

		
#For slowing the character down, lowering acceleration will take longer to deaccelerate
#creating effects such as walking on ice, etc. 
func character_decelerate():
	motion.x = move_toward(motion.x, 0, movementData.acceleration)

#For accelerating character, increase acceleration to make character faster
#increase maxspeed to make character's fastest speed faster.
func character_acceleration(inputXamount):
	#Move_toward = (initial velocity, target velocity, how much increment)
	motion.x = move_toward(motion.x, movementData.maxspeed * inputXamount, movementData.acceleration)
	

func _on_Jumpcooldown_timeout():
	jumpbuffer = false

#If user does not press jump within coyotejumptimer they cannot do a coyote jump. 
func _on_Coyotejumptimer_timeout():
	coyotejump = false
	
