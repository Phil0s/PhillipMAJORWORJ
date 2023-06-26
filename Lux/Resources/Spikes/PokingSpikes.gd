#4/02/2023 By Phillip Poking Spikes

extends Area2D

func _ready():
	pass
	
func _on_PokingSpike_body_entered(body):
	if body is MainCharacter:
		print("Poked by spikes")
