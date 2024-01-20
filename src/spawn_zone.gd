extends Marker2D
class_name spawn_point

func spawn_enemy():
	var scene = load("res://src/enemy.tscn")
	var instance = scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = position
