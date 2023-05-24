extends Node2D

onready var spawn0 = $Checkpoint_0.global_position
onready var spawn1 = $Checkpoint_1.global_position
onready var player = $Player


var levelsavefile = "res://levelsavefile.json"

var local_data = {}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if LevelSavesLoaded.data.Level[1].checkpoint == 0:
		player.global_position = spawn0
	if LevelSavesLoaded.data.Level[1].checkpoint == 1:
		player.global_position = spawn1
	if LevelSavesLoaded.data.Level[1].enemy[0] == 1:
		$WalkingEnemy.queue_free()




func _on_Exit_Checkpoint_finished():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[1].checkpoint = 0
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()



func _on_Checkpoint_1_body_entered(body):
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[1].checkpoint = 1
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()



func _on_Checkpoint_0_body_entered(body):
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[1].checkpoint = 0
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()




func _on_WalkingEnemy_body_entered(body):
	if body is MainCharacter:
		LevelSavesLoaded.data.Level[1].enemy[0] = 1
