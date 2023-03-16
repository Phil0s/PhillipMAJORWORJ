extends Node

#This is an autoloader script, so for the actual progres bar we need to get it from
#Another seperate scene
var loadingscene = load("res://Levels/Other/Loading.tscn")

#THis it the function that can be called globally when this file becomes autoloaded
func load_scene1(currentscene, nextscene):
	#Calling the var with our loaded progress bar script, I create an instance. 
	var loadingsceneinstance = loadingscene.instance()
	get_tree().get_root().call_deferred("add_child", loadingsceneinstance)
	#Instance is loaded and will pop up in the scene
	var loader = ResourceLoader.load_interactive(nextscene)
	#If the loading of the instance results in null there has been a problem
	if loader == null:
		print("Error getting next scene - " + nextscene)
		return
	
	#Current scene is the scene this function is called in, the current scene the user is on
	#Queue free means we destroy that scene
	currentscene.queue_free()
	
	#Timer to give some time for the loading screen to pop up
	yield(get_tree().create_timer(0.5), "timeout")
	
	while true:
		#Using poll function, takes the data of targeted object, in this case our next scene
		#This is defined on line 13. And breaks it up into small pieces of data and loads them
		#This is mostly useless for my project as most loads take very little time, however if I
		#Somehow make a large level then the user might get confused with the game freezing whilst
		#It loads, so this is a precaution. 
		var error = loader.poll()
		#As it goes through loading the chunks of data, if result returned is ok then increase the progressbar
		#Value to correspond to the progress percentage of the reading. The math done on line 37 
		#And most things in this file was thanks To the help of youtube videos and godot forums. 
		if error == OK:
			var progressbar = loadingsceneinstance.get_node("ProgressBar")
			progressbar.value = float(loader.get_stage())/loader.get_stage_count() * 100
		#Once at the end of the file/finishes loading all the chunks the poll function will return
		#A value saying End of File (EOF) and when we get that we delete the loadingscene and 
		#Instance in the scene we wanted to switch to. 
		elif error == ERR_FILE_EOF:
			var scene = loader.get_resource().instance()
			get_tree().get_root().call_deferred("add_child", scene)
			loadingsceneinstance.queue_free()
			print("Removed Loading Instance")
			return
		else:
			print("Error loading file - " + nextscene)
			return
