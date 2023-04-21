#extends RayCast2D
#
#var is_casting := false setget set_is_casting
#
#var fire_orders = false
#var firing = false
#
#func _ready():
#	set_physics_process(false)
#	$Line2D.points[1] = Vector2.ZERO
#
#func _unhandled_input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		self.is_casting = event.pressed
#
#func _physics_process(delta: float) -> void:
#
#
#	var cast_point := cast_to
#	force_raycast_update()
#
#	if is_colliding():
#		cast_point = to_local(get_collision_point())
#
#	$Line2D.points[1] = cast_point
#
#func set_is_casting(cast: bool) -> void:
#	is_casting = cast
#
#	if is_casting:
#		appear()
#		print("Appearing")
#	else:
#		disappear()
#	set_physics_process(is_casting)
#
#func appear():
#	$Tween.stop_all()
#	$Tween.interpolate_property($Line2D, "width", 0, 10.0, 0.2)
#	$Tween.start()
#
#func disappear():
#	$Tween.stop_all()
#	$Tween.interpolate_property($Line2D, "width", 10.0, 0, 0.1)
#	$Tween.start()
#
#
#func _on_Enemy_Drone_fire():
#	fire_orders = true










extends RayCast2D

var is_casting = false

var fire_orders = false
var firing = false
var can_cast = true

func _ready():
	#set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO

func _process(delta):
	pass
	if(fire_orders):
		is_casting = true
	else:
		is_casting = false

func _physics_process(delta):	
	var cast_point := cast_to
	force_raycast_update()
	
	

	if is_colliding():
		cast_point = to_local(get_collision_point())

	$Line2D.points[1] = cast_point
	
	laser_beam()
	
	if self.is_colliding():
		var name = self.get_collider()
		var name_string = name.to_string()
		print(name_string)
		if name_string == "Player:[KinematicBody2D:1838]":
			print("killed by lasers")
			

func laser_beam():
	if is_casting:
		self.visible = true
		appear()
	else:
		disappear()
		self.visible = false



func appear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 10.0, 0.2)
	$Tween.start()

func disappear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 10.0, 0, 0.1)
	$Tween.start()


func _on_Enemy_Drone_fire():
	fire_orders = true

func _on_Enemy_Drone_stop_fire():
	fire_orders = false
