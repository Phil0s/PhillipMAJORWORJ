extends Area2D


# Declaring Variable
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	count = 0



func _on_tutorial7msg_body_entered(body):
	if count == 0:
		if body is MainCharacter:
			print("Touched")
			TextBox.msgcalled("res://Resources/Text/Tutorial6.json")
			count = 1
