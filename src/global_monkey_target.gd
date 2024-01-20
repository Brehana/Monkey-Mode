extends Node

var player : destructable

func get_all_monkeys():
	var children = get_tree().get_current_scene().get_children()
	var monkeys = []
	for child in children:
		if(child is monkey):
			monkeys.append(child)
	return monkeys

func get_attack_ready_monkeys():
	var children = get_tree().get_current_scene().get_children()
	var monkeys = []
	for child in children:
		if(child is monkey):
			if(child._current_state != monkey.states.ATTACKING):
				monkeys.append(child)
	return monkeys
	
