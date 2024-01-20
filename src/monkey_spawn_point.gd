extends Marker2D

class_name monkey_spawn_point

func spawn_monkeys(numMonkeys):
	for i in range(0, numMonkeys):
		var scene = load("res://src/monkey.tscn")
		var instance = scene.instantiate()
		get_tree().current_scene.call_deferred("add_child", instance)
		instance.position = position
