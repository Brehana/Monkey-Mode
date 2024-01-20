extends RigidBody2D
class_name projectile

func _on_body_entered(body):
	var scene = load("res://src/projectile_shatter.tscn")
	var instance = scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = position
	if(body is destructable):
		body.receive_damage(200, self)
	queue_free()

func _on_lifetime_timer_timeout():
	queue_free()
