extends Area2D

var count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_tutorial1msg_body_entered(body):
	if count == 0:
		if body is MainCharacter:
			print("Touched")
			TextBox.msgcalled("res://Resources/Text/tutorial.json")
			count = 1
