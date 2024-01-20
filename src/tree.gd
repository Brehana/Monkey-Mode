extends StaticBody2D

class_name tree

func _on_banana_spawn_timer_timeout():
	if (MainGame.gameRunning == true):
		$Banana_spawn_timer.one_shot = true
		var scene = load("res://src/banana.tscn")
		var instance = scene.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.position = to_global((Vector2.ONE * 10).rotated(randf_range(0,PI)))
		$Banana_spawn_timer.start(randf_range(15,60))
