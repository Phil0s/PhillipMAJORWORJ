extends CanvasLayer

#Credits: Phillip 5/01/23 Baseic template credits to Afely but heavily expanded on by me

export(float) var textspeed = 0.05

onready var texttimer = $Timer
onready var name1 = $ColorRect/Name1
onready var textwords = $ColorRect/Text
onready var glitch = $Glitch
var dialogue
var playingrn = false
var anim_finished = true
var phraseNum = 0
var finished = false
var endofdialogue = false

func _ready():
	get_child(0).visible = false
	get_child(1).visible = false
	get_child(4).visible = false
	glitch.visible = false
	#get_child(2).visible = false
	

func msgcalled(selectmsg):
	endofdialogue = false
	print("reached msgcalled")
	playingrn = true
	phraseNum = 0
	finished = false
	texttimer.wait_time = textspeed
#	get_tree().paused = !get_tree().paused
#	get_child(0).visible = get_tree().paused
#	get_child(1).visible = get_tree().paused
	get_child(0).visible = true
	get_child(1).visible = true
	dialogue = getDialogue(selectmsg)
	assert(dialogue, "Dialogue not found")
	nextPhrase()
	yield(get_tree().create_timer(0.5), "timeout")
	$ColorRect/AnimationPlayer.play("Voice")
	
func _process(delta):
#	$Polygon2D.visible = finished
	if(playingrn):
#		if Input.is_action_just_pressed("ui_accept"):
#			if finished:
#				nextPhrase()
#			else:
#				textwords.visible_characters = len(textwords.text)
		if(endofdialogue):
			print("Reached here")
			$TransitionTimer.start()
			endofdialogue = false
#		if Input.is_action_just_pressed("ui_accept"):
#			textwords.visible_characters = len(textwords.text)
#	if(PauseMenu.textboxhalt and playingrn):
#		get_child(4).visible = true
#		if(anim_finished):
#			$Label/AnimationPlayer.play("New Anim")
#			anim_finished = false
			
#	if Globalscript.levelreload:
#		get_child(0).visible = false
#		get_child(1).visible = false
##		$Label/AnimationPlayer.stop()
#		print("reached end player")
#		get_child(4).visible = false
#		PauseMenu.textboxhalt = false
#		anim_finished = true
#		print("finished")
#		playingrn = false
#		finished = false
#		#queue_free()
#		return
	
func getDialogue(selectmsg) -> Array:
	var file = File.new()
	assert(file.file_exists(selectmsg), "Dialogue File path does not exist")
	
	file.open(selectmsg, File.READ)
	var data = file.get_as_text()
	
	var output = parse_json(data)
	
	file.close()
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
	
func nextPhrase() -> void:
	endofdialogue = false
	if phraseNum >= len(dialogue):
		$ColorRect/AnimationPlayer.play("NoVoice")
		yield(get_tree().create_timer(1), "timeout")
#		get_tree().paused = !get_tree().paused
#		get_child(0).visible = get_tree().paused
#		get_child(1).visible = get_tree().paused
		get_child(0).visible = false
		get_child(1).visible = false
#		$Label/AnimationPlayer.stop()
		print("reached end player")
		get_child(4).visible = false
		PauseMenu.textboxhalt = false
		anim_finished = true
		print("finished")
		playingrn = false
		finished = false
		#queue_free()
		return
	finished = false
	
	name1.text = dialogue[phraseNum]["Name"]
	textwords.text = dialogue[phraseNum]["Text"]
	
	textwords.visible_characters = 0
	
	while textwords.visible_characters < len(textwords.text):
			$AudioStreamPlayer.play()
			textwords.visible_characters += 1
			texttimer.start()
			yield(texttimer, "timeout")
	endofdialogue = true
	finished = true
	phraseNum += 1
	return


func _on_AnimationPlayer_animation_finished(anim_name):
	anim_finished = true
	$Label/AnimationPlayer.stop()
	get_child(4).visible = false
	PauseMenu.textboxhalt = false


func _on_TransitionTimer_timeout():
	nextPhrase()
