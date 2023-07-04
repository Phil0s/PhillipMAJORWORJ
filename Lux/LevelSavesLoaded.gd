extends Node

var levelsavefile = "res://levelsavefile.json"

var default_data = {
	"Level" : [
		{"checkpoint" : 0, "enemy" : [-1], "health" : 100},
		{"checkpoint" : 0, "enemy" : [-1], "health" : 100},
		{"checkpoint" : 0, "enemy" : [], "health" : 100},
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
		print(data)
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
