extends Particles2D
#Created: Phillip 2/01/23 Credit to Rungeon

func _ready():
	yield(get_tree().create_timer(2), "timeout")
	queue_free()
