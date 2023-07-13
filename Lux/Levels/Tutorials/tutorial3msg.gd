extends Area2D
#Created: Phillip 5/01/2023
# Declaring Variable
var count = 0
onready var label = $Label2
var entered = false
# Called when the node enters the scene tree for the first time.
func _ready():
	count = 0
	
func _process(delta):
	if(entered):
		label.visible = true
		if Input.is_action_just_pressed("MSG"):
			TextBox.msgcalled("res://Resources/Text/Tutorial2.json")
	if(!entered):
		label.visible = false


func _on_tutorial3msg_body_entered(body):
	if body is MainCharacter:		
		entered = true



func _on_tutorial3msg_body_exited(body):
	if body is MainCharacter:
		entered = false
