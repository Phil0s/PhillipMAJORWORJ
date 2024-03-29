extends Area2D


# Declaring Variable
var count = 0
var entered = false
onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	count = 0

func _process(delta):
	if(entered):
		label.visible = true
		if Input.is_action_just_pressed("MSG"):
			TextBox.msgcalled("res://Resources/Text/level1msg2.json")
	if(!entered):
		label.visible = false

func _on_Level1msg2_body_entered(body):
	if body is MainCharacter:
		entered = true


func _on_Level1msg2_body_exited(body):
	if body is MainCharacter:
		entered = false
