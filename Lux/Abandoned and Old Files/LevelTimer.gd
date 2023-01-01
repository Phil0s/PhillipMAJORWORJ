extends Node2D

onready var RecordLabel = $Label2
onready var LiveLabel = $Label
var time = 0
var timer_on = false
var record = 0
var firstime = 1

func _process(delta):
	if timer_on:
		time += delta
	var miliseconds = fmod(time,1) * 1000
	var seconds = fmod(time,60)
	var minutes = fmod(time,60*60) / 60
	
	var time_passed = "%02d : %02d : %03d" % [minutes,seconds, miliseconds]
	LiveLabel.text = time_passed
	
	

func _on_Button_pressed():
	timer_on = true


func _on_Button3_pressed():
	time = 0


func _on_Button4_pressed():
	var miliseconds = fmod(time,1) * 1000
	var seconds = fmod(time,60)
	var minutes = fmod(time,60*60) / 60
	var time_passed = "%02d : %02d : %03d" % [minutes,seconds, miliseconds]
	if firstime == 1:
		print("First time")
		record =  time_passed
		RecordLabel.text = record
		firstime = 0 
	elif firstime == 0:
		if time_passed > record:
			record = record
			RecordLabel.text = record
		elif time_passed < record:
			record = time_passed
			RecordLabel.text = record

func _on_Button2_pressed():
	timer_on = false
