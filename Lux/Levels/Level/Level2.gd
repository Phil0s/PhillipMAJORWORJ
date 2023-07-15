extends Node2D
# Get child node as variables
onready var spawn0 = $Checkpoint_0.global_position
onready var spawn1 = $Checkpoint_1.global_position
onready var player = $Player

# Declare Variables
var levelsavefile = ProjectSettings.globalize_path("user://levelsavefile.json")

var local_data = {}



# Called when the node enters the scene tree for the first time.
func _ready():
	player._set_health(LevelSavesLoaded.data.Level[2].health)
	if LevelSavesLoaded.data.Level[2].checkpoint == 0:
		player.global_position = spawn0
	if LevelSavesLoaded.data.Level[2].checkpoint == 1:
		player.global_position = spawn1
	if 	LevelSavesLoaded.data.Level[2].enemy[0] == 1:
		$SkeletonEnemy2.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[1] == 1:
		$SkeletonEnemy3.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[2] == 1:
		$SkeletonEnemy.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[3] == 1:
		$ToasterBot.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[4] == 1:
		$SkeletonEnemy4.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[5] == 1:
		$ToasterBot2.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[6] == 1:
		$ToasterBot3.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[7] == 1:
		$SkeletonEnemy5.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[8] == 1:
		$ToasterBot4.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[9] == 1:
		$ShockHead.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[10] == 1:
		$SkeletonEnemy6.queue_free()
	if 	LevelSavesLoaded.data.Level[2].enemy[11] == 1:
		$ToasterBot5.queue_free()

func _on_Checkpoint_1_body_entered(body):
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[2].checkpoint = 1
	LevelSavesLoaded.data.Level[2].health = $Player.current_health
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()



func _on_Checkpoint_0_body_entered(body):
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[2].checkpoint = 0
	LevelSavesLoaded.data.Level[2].health = $Player.current_health
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()


func _on_SkeletonEnemy2_dead():
	LevelSavesLoaded.data.Level[2].enemy[0] = 1


func _on_SkeletonEnemy3_dead():
	LevelSavesLoaded.data.Level[2].enemy[1] = 1


func _on_SkeletonEnemy_dead():
	LevelSavesLoaded.data.Level[2].enemy[2] = 1


func _on_ToasterBot_dead():
	LevelSavesLoaded.data.Level[2].enemy[3] = 1


func _on_SkeletonEnemy4_dead():
	LevelSavesLoaded.data.Level[2].enemy[4] = 1


func _on_ToasterBot2_dead():
	LevelSavesLoaded.data.Level[2].enemy[5] = 1


func _on_ToasterBot3_dead():
	LevelSavesLoaded.data.Level[2].enemy[6] = 1


func _on_Door_Checkpoint_finished():
	var file = File.new()
	file.open(levelsavefile, File.WRITE)	
	LevelSavesLoaded.data.Level[2].checkpoint = 0
	LevelSavesLoaded.data.Level[2].health = 100
	LevelSavesLoaded.data.Level[2].enemy[0] = -1
	LevelSavesLoaded.data.Level[2].enemy[1] = -1
	LevelSavesLoaded.data.Level[2].enemy[2] = -1
	LevelSavesLoaded.data.Level[2].enemy[3] = -1
	LevelSavesLoaded.data.Level[2].enemy[4] = -1
	LevelSavesLoaded.data.Level[2].enemy[5] = -1
	LevelSavesLoaded.data.Level[2].enemy[6] = -1
	LevelSavesLoaded.data.Level[2].enemy[7] = -1
	LevelSavesLoaded.data.Level[2].enemy[8] = -1
	LevelSavesLoaded.data.Level[2].enemy[9] = -1
	LevelSavesLoaded.data.Level[2].enemy[10] = -1
	LevelSavesLoaded.data.Level[2].enemy[11] = -1
	file.store_line(to_json(LevelSavesLoaded.data))
	file.close()


func _on_SkeletonEnemy5_dead():
	LevelSavesLoaded.data.Level[2].enemy[7] = 1


func _on_ToasterBot4_dead():
	LevelSavesLoaded.data.Level[2].enemy[8] = 1


func _on_ShockHead_dead():
	LevelSavesLoaded.data.Level[2].enemy[9] = 1


func _on_SkeletonEnemy6_dead():
	LevelSavesLoaded.data.Level[2].enemy[10] = 1


func _on_ToasterBot5_dead():
	LevelSavesLoaded.data.Level[2].enemy[11] = 1
