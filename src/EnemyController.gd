extends Node

var spawnTimer : Timer
var spawnTime
@onready var numberEnemies := 0
@onready var roundNumber := 1

const MAX_ENEMIES := 30

func start():
	spawnTimer = Timer.new()
	spawnTimer.timeout.connect(spawn_enemy)
	get_tree().current_scene.add_child(spawnTimer)
	spawnTimer.one_shot = true
	spawnTimer.start(3)
	
func spawn_enemy():
	if(numberEnemies <= MAX_ENEMIES && MainGame.enemiesRemaining > 0):
		var children = get_tree().current_scene.get_children()
		var spawnPoints = []
		for child in children:
			if child is spawn_point:
				spawnPoints.append(child)
		if(spawnPoints.is_empty() == false):
			spawnPoints.pick_random().spawn_enemy()
	if(MainGame.timeAlive <= 30):
		spawnTimer.start(4)
	if(MainGame.timeAlive > 30 && MainGame.timeAlive <= 45):
		spawnTimer.start(3.5)
	if(MainGame.timeAlive > 45 && MainGame.timeAlive <= 55):
		spawnTimer.start(3)
	if(MainGame.timeAlive > 55 && MainGame.timeAlive <= 65):
		spawnTimer.start(2.5)
	if(MainGame.timeAlive > 65 && MainGame.timeAlive <= 75):
		spawnTimer.start(2)
	if(MainGame.timeAlive >= 75):
		spawnTimer.start(1)
