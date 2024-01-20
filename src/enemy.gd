extends steering_agent

class_name  enemy

enum enemyState{RETREAT, ADVANCE, ATTACK}
var currentState : enemyState

var attackReady
var mouseHovering
const ATTACK_RANGE = 300


func _ready():
	attackReady = true
	currentState = enemyState.ATTACK
	
func _physics_process(_delta):
	if(damageQueue.is_empty() == false):
		var damageStruct = damageQueue.pop_front()
		_health -= damageStruct[0]
		if(_health <= 0):
			destroy()
	if(GlobalMonkeyTarget.player != null):
		if(position.distance_to(GlobalMonkeyTarget.player.position) >= ATTACK_RANGE):
			set_ADVANCE()
		else:
			set_ATTACK()
		
	match currentState:
		enemyState.ADVANCE:
			if(GlobalMonkeyTarget.player != null):
				arrive_at(GlobalMonkeyTarget.player.position)
		enemyState.RETREAT:
			pass
		enemyState.ATTACK:
			if(attackReady == true && GlobalMonkeyTarget.player != null):
				arrive_at(GlobalMonkeyTarget.player.position)
				attack(position, position.direction_to(GlobalMonkeyTarget.player.position), 200)


func receive_damage(damage, attacker):
	queue_damage(damage, attacker)
	$AnimationPlayer.play("TakeDamage",-1,2)

func set_ADVANCE():
	currentState = enemyState.ADVANCE
func set_ATTACK():
	currentState = enemyState.ATTACK
func set_RETREAT():
	currentState = enemyState.RETREAT
	
func attack(spawnPosition, direction, force):
	var scene = load("res://src/projectile.tscn")
	var instance = scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = spawnPosition
	instance.apply_central_impulse(direction.normalized() * force)
	attackReady = false
	$Attack_Cooldown.start()
	
func destroy():
	#Spawn Blood Splatter
	var scene = load("res://src/blood_splatter.tscn")
	var instance = scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = position
	#Spawn Gib
	scene = load("res://src/gib.tscn")
	instance = scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = position
	queue_free()
	
func _on_attack_cooldown_timeout():
	attackReady = true
func _on_tree_entered():
	EnemyController.numberEnemies += 1
	MainGame.enemiesRemaining -= 1
func _on_tree_exited():
	EnemyController.numberEnemies -= 1
	MainGame.totalKills += 1
