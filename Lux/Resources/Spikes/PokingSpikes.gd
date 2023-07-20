#4/02/2023 By Phillip Poking Spikes

extends Area2D

# Called when node first enters the scene
func _ready():
	pass
	
# These spikes have an area constantly looking for another body/area entering it
#
# @param {string} body - This is the name of the body entering area
# @returns none
func _on_PokingSpike_body_entered(body):
	if body is MainCharacter:
		monitorable = false
		monitoring = false
