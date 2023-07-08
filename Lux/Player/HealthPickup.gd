extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 
	
	

# This code only gets rid of the healthpickup, for actual code regarding player health increase it is
# found inside the player's code at the very bottom
func _on_HealthPickup_body_entered(body):
	if body is MainCharacter:
		$AudioStreamPlayer2D.play()
		yield($AudioStreamPlayer2D, "finished")
		queue_free()
