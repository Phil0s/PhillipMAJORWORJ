extends Node2D

onready var spawn0 = $Checkpoint_0.global_position
onready var spawn1 = $Checkpoint_1.global_position
onready var player = $Player

var levelsavefile = "res://levelsavefile.json"

var local_data = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	if LevelSavesLoaded.data.Level[0].checkpoint == 0:
		player.global_position = spawn0
	if LevelSavesLoaded.data.Level[0].checkpoint == 1:
		player.global_position = spawn1
		
		
#	LevelTimer.timer_on = true
#	LevelTimer.time = 0
#	LevelTimer.final_time = 0


func _on_Checkpoint_0_Checkpoint_reached0():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[0].checkpoint = 0
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()
	
func _on_Checkpoint_1_Checkpoint_reached1():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[0].checkpoint = 1
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()


func _on_tutorialfinish_Checkpoint_finished():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[0].checkpoint = 0
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()
