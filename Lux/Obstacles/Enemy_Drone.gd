extends KinematicBody2D

signal fire

signal stop_fire

#Credits: GDQuest - Pathfinding

export var path_to_player := NodePath() #Get the node path of the player node 

onready var _player := get_node(path_to_player) #Calling the node that is found in var path to player

export var path_to_drone_int_pos_placeholder := NodePath() #Get the node path of the player node 

onready var _drone_int_pos_sprite := get_node(path_to_drone_int_pos_placeholder)

onready var navigation_agent_2d = $NavigationAgent2D
onready var timer = $Timer
onready var drone_sprite = $Drone_Sprite
onready var tracking_timer = $TrackingTimer
#onready var raycast = $Drone_Sprite/Raycast2D
onready var drone_intial_pos = self.global_position 
onready var lasers = $lasers

var _velocity := Vector2.ZERO

var not_detected = true
var pursuiting = false
var rotationSpeed = 0.35
var finished = false
var rays_are_detecting_confirmed = false

var timer_alr = false
var fire_lasers = false
var can_fire = true

func _ready():
	rays_are_detecting_confirmed = false
	update_path()
#	finished = false
	pursuiting = false
#	not_detected = true
	timer.connect("timeout", self, "update_path") #Get position of player node every {Timer length}



	
func _physics_process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		#stop_laser()
		return
	update_path()
	
	if(!not_detected) and rays_are_detecting_confirmed:
		fire_lasers = true
		fire_laser()
	else:
		fire_lasers = false

	#Player entered Area2D and rays are seeing player
	if(!not_detected) and rays_are_detecting_confirmed:
			pursuiting = true
#		if raycast.is_colliding():
#			var collider = raycast.get_collider()
#			if collider is MainCharacter:
			rotatetotarget(_player, delta)	
			var direction := global_position.direction_to(navigation_agent_2d.get_next_location() ) 	
			var desired_velocity := direction * 20
			var steering := (desired_velocity - _velocity) * delta * 2.0 
			_velocity += steering	
			#sprite_orientation()	
			_move()
	#Player still in area, we will pursuit despite losing our rays for a period of time
	if(!not_detected) and pursuiting:
		rotatetotarget(_player, delta)	
		var direction := global_position.direction_to(navigation_agent_2d.get_next_location() ) 	
		var desired_velocity := direction * 20
		var steering := (desired_velocity - _velocity) * delta * 4.0 
		_velocity += steering	
		#sprite_orientation()	
		_move()
		if(!timer_alr):
			tracking_timer.start()
			timer_alr = true

	#If whilst pursuiting the player leaves our area we stop pursuiting
	if(not_detected) and pursuiting:
		pursuiting = false
		#stop_laser()
#		if(!timer_alr):
#			tracking_timer.start()
#			timer_alr = true
	
	#player in area BUT cannot see us and is not pursuiting (Since we are still in area we rely on the chase timer to expire) 
	if(!not_detected) and !rays_are_detecting_confirmed and !pursuiting:
			#stop_laser()
			timer_alr = false
			pursuiting = false
#		if raycast.is_colliding():
#			var collider = raycast.get_collider()a
#			if collider is MainCharacter:
			#rotatetotarget(_player, delta)	
			var direction := global_position.direction_to(navigation_agent_2d.get_next_location() ) 	
			var desired_velocity := direction * 20
			var steering := (desired_velocity - _velocity) * delta * 4.0 
			_velocity += steering	
			#sprite_orientation()	
			_move()
			
	#If no longer in area and no longer can see then lets retur back		
	if(not_detected) and !rays_are_detecting_confirmed:
			#stop_laser()
			timer_alr = false
			pursuiting = false
			#rotatetotarget(_drone_int_pos_sprite, delta)
			var direction := global_position.direction_to(navigation_agent_2d.get_next_location() ) 	
			var desired_velocity := direction * 15
			var steering := (desired_velocity - _velocity) * delta * 4.0 
			_velocity += steering	
			#sprite_orientation()	
			_move()
#Make drone move
func _move():
	_velocity = move_and_slide(_velocity)
#Updates whether drone to go back 'home' or chase player	
func update_path() -> void:
	var drone_current_pos = self.global_position
	if(!not_detected) and rays_are_detecting_confirmed:
		navigation_agent_2d.set_target_location(_player.global_position)
	if(!not_detected) and !rays_are_detecting_confirmed and pursuiting:
		navigation_agent_2d.set_target_location(_player.global_position)
	# Moving backwards lost track of player	
	if(!not_detected) and !rays_are_detecting_confirmed and !pursuiting:
		navigation_agent_2d.set_target_location(drone_intial_pos)
	if not_detected and (drone_current_pos != drone_intial_pos):
		navigation_agent_2d.set_target_location(drone_intial_pos)

func _on_Area2D_body_entered(body):
	if body is MainCharacter:
		not_detected = false


func _on_Area2D_body_exited(body):
	if body is MainCharacter:
		not_detected = true

#TFinding character position and dir took a while for me figure out which way its suppose to facing, etc. Desk checking actually helped!
#func sprite_orientation():
#	var player_pos = _player.global_position
#	var drone_pos = self.global_position
#	var player_pos_y = (player_pos.x)
#	var drone_pos_y = int(drone_pos.x)
#	var vector_dir = int(_velocity.x)
#	if vector_dir > 0 and (player_pos_y < drone_pos_y):
#		drone_sprite.flip_v = true
#	if vector_dir > 0 and (player_pos_y > drone_pos_y):
#		drone_sprite.flip_v = false
#	#Moving Left and player to the left
#	if vector_dir < 0 and (player_pos_y < drone_pos_y):
#		drone_sprite.flip_v = true
#	#Moving Left and player to the right
#	if vector_dir < 0 and (player_pos_y > drone_pos_y):
#		drone_sprite.flip_v = false	
#
##	if vector_dir == 0:
#	pass

#func rotatetotarget(target, delta):
	#var direction = (target.global_position - global_position)
	#var angleTo = drone_sprite.transform.x.angle_to(direction)
	#drone_sprite.rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))
	#Once rotation obtained, how fast the rotation is, is calculated by multiplying delta with rotationspeed
	#This causes the sprite to overshoot the value however, so we take the absolute value  of how much more we need to rotate and take which ever value of the abs and calculated rotationspeed is smaller 
func fire_laser():
	if(fire_lasers):
		if(can_fire):
			can_fire = false
			emit_signal("fire")
			print("Reached first")
			yield(get_tree().create_timer(3), "timeout")
			emit_signal("stop_fire")
			print("Reached 2nd")
			yield(get_tree().create_timer(3), "timeout")
			can_fire = true
#func stop_laser():
#	emit_signal("stop_fire")

func rotatetotarget(target, delta):
	var direction = (target.global_position - global_position)
	var angleTo = lasers.transform.x.angle_to(direction)
	lasers.rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))

func _on_RaycastBox_rays_detecting():
	rays_are_detecting_confirmed = true


func _on_RaycastBox_rays_lost():
	rays_are_detecting_confirmed = false


func _on_TrackingTimer_timeout():
	pursuiting = false
