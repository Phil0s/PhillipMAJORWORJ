extends Area2D
#Created: Phillip 5/01/2023

var count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	count = 0


func _on_tutorial3msg_body_entered(body):
	if count == 0:
		if body is MainCharacter:
			print("Touched")
			TextBox.msgcalled("res://Resources/Text/tutorial3.json")
			count = 1

