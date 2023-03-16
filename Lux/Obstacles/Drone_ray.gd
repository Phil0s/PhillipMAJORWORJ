extends RayCast2D



#Casting multiple rays as one ray is not accurate enough
var angle_of_visioncone = deg2rad(30.0)
var max_view_distance = 800.0
var angle_between_rays = deg2rad(5.0)

var target:  MainCharacter = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func generate_raycasts() -> void:
#	var ray_count = angle_of_visioncone / angle_between_rays #Number of rays
#
#	for index in ray_count: 
#		var ray = RayCast2D.new()
#		var angle = angle_between_rays * (index - ray_count / 2.0)
#		ray.cast_to = Vector2.UP.rotated(angle) * max_view_distance #Calculate where each ray casts
#		add_child(ray)
#		ray.enabled = true
#
#func _physics_process(delta: float) -> void:
#	for ray in get_children():
#		if ray.is_colliding() and get_collider() is MainCharacter:
#			target = get_collider()
#			emit_signal("in_sight")
#			print("Emiited")
#		else:
#			emit_signal("lost_track")
		
	
