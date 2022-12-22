extends Node2D

signal dashorb_collected(value)


func _on_Dash_Orb_body_entered(body):
	if body is MainCharacter:
		emit_signal("dashorb_collected", 1)
		queue_free()
