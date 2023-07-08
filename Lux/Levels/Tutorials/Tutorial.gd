extends Node2D
# Created: Phillip Early 2023
# About: Handles level data for Tutorial

# Declaring child nodes as variable
onready var spawn0 = $Checkpoint_0.global_position
onready var spawn1 = $Checkpoint_1.global_position
onready var spawn2 = $Checkpoint_2.global_position
onready var player = $Player

# Declaring variables
var levelsavefile = "res://levelsavefile.json"
var local_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	player._set_health(LevelSavesLoaded.data.Level[0].health)
	if LevelSavesLoaded.data.Level[0].checkpoint == 0:
		player.global_position = spawn0
	if LevelSavesLoaded.data.Level[0].checkpoint == 1:
		player.global_position = spawn1
	if LevelSavesLoaded.data.Level[0].checkpoint == 2:
		player.global_position = spawn2
	if LevelSavesLoaded.data.Level[0].enemy[0] == 1:
		$SkeletonEnemy.queue_free()

# Signals from other nodes such as enemies and checkpoints
func _on_Checkpoint_0_Checkpoint_reached0():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[0].checkpoint = 0
	LevelSavesLoaded.data.Level[0].health = $Player.current_health
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()
	
func _on_Checkpoint_1_Checkpoint_reached1():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[0].checkpoint = 1
	LevelSavesLoaded.data.Level[0].health = $Player.current_health
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()


func _on_Door_Checkpoint_finished():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[0].checkpoint = 0
	LevelSavesLoaded.data.Level[0].health = 100
	LevelSavesLoaded.data.Level[0].enemy[0] = -1
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()


func _on_Checkpoint_2_Checkpoint_reached2():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[0].checkpoint = 2
	LevelSavesLoaded.data.Level[0].health = $Player.current_health
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()


func _on_SkeletonEnemy_dead():
	LevelSavesLoaded.data.Level[0].enemy[0] = 1
