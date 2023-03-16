extends Area2D
#Created: Phillip 5/01/2023

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	count = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_tutorial5msg_body_entered(body):
	if count == 0:
		if body is MainCharacter:
			print("Touched")
			TextBox.msgcalled("res://Resources/Text/tutorial5.json")
			count = 1
