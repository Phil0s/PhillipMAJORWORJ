extends Node

#var levelsavefile = ProjectSettings.globalize_path("user://levelsavefile.json")
var levelsavefile = "user://levelsavefile.json"
var default_data = {
	"Level" : [
		{"checkpoint" : 0, "enemy" : [-1], "health" : 100},
		{"checkpoint" : 0, "enemy" : [-1,-1,-1,-1,-1,-1,-1], "health" : 100},
		{"checkpoint" : 0, "enemy" : [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1], "health" : 100},
		{"checkpoint" : 0, "enemy" : [], "health" : 100},
		{"checkpoint" : 0, "enemy" : [], "health" : 100},
	]
}

var data = {}

func _ready():
	var file = File.new()
	if not file.file_exists(levelsavefile):
		data = default_data
		file.open(levelsavefile, File.WRITE)
		file.store_line(to_json(data))
		file.close()
	if file.file_exists(levelsavefile):
		file.open(levelsavefile, File.READ)
		var text = file.get_as_text()
		data = parse_json(text)
		#Data Validation
		var array = data.Level[0].enemy
		var arraysize = array.size()
		if(arraysize != 1):
			print("Level0 Enemy Error")
			data.Level[0].enemy = default_data.Level[0].enemy
			reset_enemy(0)
		array = data.Level[1].enemy
		arraysize = array.size()
		if(arraysize != 7):
			print("Level1 Enemy Error")
			data.Level[1].enemy = default_data.Level[1].enemy
			reset_enemy(1)
		array = data.Level[2].enemy
		arraysize = array.size()
		if(arraysize != 12):
			print("Level2 Enemy Error")
			data.Level[2].enemy = default_data.Level[2].enemy
			reset_enemy(2)
		var checkpoint = data.Level[0].checkpoint
		if checkpoint < 0 or checkpoint > 3:
			reset_checkpoint(0)
			data.Level[0].checkpoint = default_data.Level[0].checkpoint
		checkpoint = data.Level[1].checkpoint
		if checkpoint < 0 or checkpoint > 2:
			reset_checkpoint(1)
			data.Level[1].checkpoint = default_data.Level[1].checkpoint
		checkpoint = data.Level[2].checkpoint
		if checkpoint < 0 or checkpoint > 2:
			reset_checkpoint(2)
			data.Level[2].checkpoint = default_data.Level[2].checkpoint
		data.Level[0].checkpoint = int(data.Level[0].checkpoint)
		data.Level[1].checkpoint = int(data.Level[1].checkpoint)
		data.Level[2].checkpoint = int(data.Level[2].checkpoint)
		var health = data.Level[0].health
		if health < 0 or health > 100:
			reset_health(0)
			data.Level[0].health = default_data.Level[0].health
		health = data.Level[1].health
		if health < 0 or health > 100:
			reset_health(1)
			data.Level[1].health = default_data.Level[1].health
		health = data.Level[2].health
		if health < 0 or health > 100:
			reset_health(2)
			data.Level[2].health = default_data.Level[2].health
		print(data)
		file.close()


func reset_health(level):
	var file = File.new()
	if file.file_exists(levelsavefile):
		file.open(levelsavefile, File.WRITE)	
		data.Level[level].health = default_data.Level[level].health
		file.store_line(to_json(LevelSavesLoaded.data))
		file.close()	
		
	
	
	
func reset_checkpoint(level):
	var file = File.new()
	if file.file_exists(levelsavefile):
		file.open(levelsavefile, File.WRITE)	
		data.Level[level].checkpoint = default_data.Level[level].checkpoint
		file.store_line(to_json(LevelSavesLoaded.data))
		file.close()	
	
func reset_enemy(level):
	var file = File.new()
	if file.file_exists(levelsavefile):
		file.open(levelsavefile, File.WRITE)	
		data.Level[level].enemy = default_data.Level[level].enemy
		file.store_line(to_json(LevelSavesLoaded.data))
		file.close()	


func _reset(level):
	var file = File.new()
	if file.file_exists(levelsavefile):
		file.open(levelsavefile, File.WRITE)	
		data.Level[level].checkpoint = 0
		data.Level[level].health = 100
		if(level == 0):
			data.Level[level].enemy[0] = -1
		file.store_line(to_json(LevelSavesLoaded.data))
		file.close()
