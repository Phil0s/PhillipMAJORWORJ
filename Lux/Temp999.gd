extends Node2D

var levelsavefile = "res://levelsavefile.json"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var default_data = {
	"Level" : [
		{"checkpoint" : 0, "Enemy" : []},
		{"checkpoint" : 0, "Enemy" : []},
		{"checkpoint" : 0, "Enemy" : []},
		{"checkpoint" : 0, "Enemy" : []},
		{"checkpoint" : 0, "Enemy" : []},
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
		print(data.Level[0])
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
