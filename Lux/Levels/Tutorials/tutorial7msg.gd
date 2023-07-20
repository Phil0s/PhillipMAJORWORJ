extends Area2D


# Declaring Variable
var count = 0
var entered = false
onready var label = $Label6

# Called when the node enters the scene tree for the first time.
func _ready():
	count = 0

func _process(delta):
	if(entered):
		label.visible = true
		if Input.is_action_just_pressed("MSG"):
			TextBox.msgcalled("res://Resources/Text/Tutorial6.json")
	if(!entered):
		label.visible = false



# These messages have an area constantly looking for another body/area entering it
#
# @param {string} body - This is the name of the body entering area
# @returns none


func _on_tutorial7msg_body_entered(body):
	if body is MainCharacter:
		entered = true



func _on_tutorial7msg_body_exited(body):
	if body is MainCharacter:
		entered = false
