extends Node2D

onready var spawn0 = $Checkpoint_0.global_position
onready var spawn1 = $Checkpoint_1.global_position
onready var player = $Player

var levelsavefile = "res://levelsavefile.txt"

var checkpoint1 = 0

var levelsaves_dictionary = {"level1" : checkpoint1}

# Called when the node enters the scene tree for the first time.
func _ready():
	if LevelSavesLoaded.checkpoint1 == 0:
		player.global_position = spawn0
	if LevelSavesLoaded.checkpoint1 == 1:
		player.global_position = spawn1
	LevelTimer.timer_on = true
	LevelTimer.time = 0
	LevelTimer.final_time = 0


func _on_Checkpoint_0_Checkpoint_reached0():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	checkpoint1 = 0
	levelsaves_dictionary = {"level1" : checkpoint1}
	file.store_line(to_json(levelsaves_dictionary))
	file.close()

func _on_Checkpoint_1_Checkpoint_reached1():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	checkpoint1 = 1
	levelsaves_dictionary = {"level1" : checkpoint1}
	file.store_line(to_json(levelsaves_dictionary))
	file.close()


func _on_tutorialfinish_Checkpoint_finished():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	checkpoint1 = 0
	levelsaves_dictionary = {"level1" : checkpoint1}
	file.store_line(to_json(levelsaves_dictionary))
	file.close()
