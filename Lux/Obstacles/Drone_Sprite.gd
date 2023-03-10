extends Sprite

#Created 10/03/2023 by me

signal rays_detecting
signal rays_lost

export var path_to_player := NodePath() #Get the node path of the player node 

onready var _player := get_node(path_to_player)
#Rays
var angle_cone_of_vision := deg2rad(30.0)
var max_view_distance := 2000
var angle_between_rays := deg2rad(5.0)
var rotationSpeed = 5

#Create three rays that are spaced out by set angles, facing right as seen in Vector.RIGHT of its parent object
func generate_raycasts() -> void:
	var ray_count := angle_cone_of_vision / angle_between_rays

	for index in ray_count:
			var ray := RayCast2D.new()
			var angle = angle_between_rays * (index - ray_count / 2.0)
			ray.set_collision_mask_bit(2, true)
			ray.set_collision_mask_bit(0, true)
			ray.cast_to = Vector2.RIGHT.rotated(angle) * max_view_distance
			add_child(ray)
			ray.enabled = true

			
# Called when the node enters the scene tree for the first time.
func _ready():
	generate_raycasts()

func _physics_process(delta):
	_rotate(_player, delta)
	for ray in get_children():
		if ray.is_colliding() and ray.get_collider() is MainCharacter:
			emit_signal('rays_detecting')
		else:
			emit_signal('rays_lost')
	

func _rotate(target, delta):
	var direction = (target.global_position - global_position)
	var angleTo = self.transform.x.angle_to(direction)
	self.rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
