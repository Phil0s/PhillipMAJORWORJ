extends Area2D


export(int) var id = 0

var lock_portal = false

func do_lock():
	lock_portal = true
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(2), "timeout")
	lock_portal = false
