extends Area2D


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


func _on_tutorial6msg_body_entered(body):
	if count == 0:
		if body is MainCharacter:
			print("Touched")
			TextBox.msgcalled("res://Resources/Text/Tutorial5.json")
			count = 1
