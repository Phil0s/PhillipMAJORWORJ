extends Node

var levelsavefile = "res://levelsavefile.txt"

var checkpoint1 = 0
var checkpoint2 = 0
var checkpoint3 = 0
var checkpoint4 = 0
var checkpoint5 = 0
var checkpoint6 = 0

var save = 0

var levelsaves_dictionary = {"level1" : checkpoint1}


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	if(file.file_exists(levelsavefile)): 
		file.open(levelsavefile, File.READ)
		var read_dictionary = parse_json(file.get_line())
		checkpoint1 = int(read_dictionary["level1"])
		file.close()
		

