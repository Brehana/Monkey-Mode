class_name destructable extends RigidBody2D

@export var _health : float

var damageQueue = []

func _process(_delta):
	if(damageQueue.is_empty() == false):
		var damageStruct = damageQueue.pop_front()
		_health -= damageStruct[0]
		if(_health <= 0):
			destroy()

func queue_damage(damage, attacker):
	var damageStruct = [damage, attacker]
	damageQueue.push_back(damageStruct)

func receive_damage(damage, attacker):
	queue_damage(damage, attacker)
		
func destroy():
	queue_free()
