extends Sprite


func _physics_process(delta):
	#Module a is the alpha
	#Remember Lerp is a gradual effect, so it is gradually decreasing by 0.1
	modulate.a = lerp(modulate.a, 0, 0.1)
	if(modulate.a < 0.01):
		#Once effect clears out remove the object
		queue_free()
