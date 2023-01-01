extends Particles2D
#Created: Phillip --/11/22 from Rungeon's video

func _ready():
	yield(get_tree().create_timer(2), "timeout")
	queue_free()
