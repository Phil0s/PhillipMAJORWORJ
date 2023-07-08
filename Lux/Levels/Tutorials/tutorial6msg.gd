extends Area2D


# Declaring Variable
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	count = 0


func _on_tutorial6msg_body_entered(body):
	if count == 0:
		if body is MainCharacter:
			print("Touched")
			TextBox.msgcalled("res://Resources/Text/Tutorial5.json")
			count = 1
