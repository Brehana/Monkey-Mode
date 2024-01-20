extends Node2D


func _on_despawn_timer_timeout():
	queue_free()
