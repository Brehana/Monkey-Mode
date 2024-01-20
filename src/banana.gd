extends RigidBody2D

class_name banana

func add_monkeys():
	var children = get_tree().current_scene.get_children()
	var spawn_points = []
	for child in children:
		if(child is monkey_spawn_point):
			spawn_points.append(child)
	spawn_points.pick_random().spawn_monkeys(5)


func _on_body_entered(body):
	if body is monkey:
		var scene = load("res://src/projectile_shatter.tscn")
		var instance = scene.instantiate()
		instance.set_shatter_color(Color.YELLOW)
		get_tree().current_scene.add_child(instance)
		instance.position = position
		add_monkeys()
		queue_free()
