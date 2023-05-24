extends Node

var levelsavefile = "res://levelsavefile.json"

var default_data = {
	"Level" : [
		{"checkpoint" : 0, "enemy" : [], "score" : 0},
		{"checkpoint" : 0, "enemy" : [], "score" : 0},
		{"checkpoint" : 0, "enemy" : [], "score" : 0},
		{"checkpoint" : 0, "enemy" : [], "score" : 0},
		{"checkpoint" : 0, "enemy" : [], "score" : 0},
	]
}

var data = {}


# Called when the node enters the scene tree for the first time.
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
		file.close()
		

