extends Area2D

var count = 0


func _ready():
	count = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_tutorial8msg_body_entered(body):
		if count == 0:
			if body is MainCharacter:
				print("Touched")
				TextBox.msgcalled("res://Resources/Text/tutorial7.json")
				count = 1
