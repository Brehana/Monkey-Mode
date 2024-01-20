extends Node

@onready var largestBand = 0
@onready var currentBandSize = 0
@onready var totalKills = 0
@onready var timeAlive = 0

@onready var gameRunning = false

const WAVE_SIZE = 200
var enemiesRemaining

func _ready():
	$GameTimer.timeout.connect(increment_time_alive)
	enemiesRemaining = WAVE_SIZE

func start():
	largestBand = 0
	currentBandSize = 0
	totalKills = 0
	timeAlive = 0
	var children = get_tree().current_scene.get_children()
	#Get/set player reference.
	var player
	for child in children:
		if child is player_character:
			player = child
	if(player != null):
		GlobalMonkeyTarget.player = player
	#Start Enemy spawn
	EnemyController.start()
	#Count band size
	largestBand = GlobalMonkeyTarget.get_all_monkeys().size()
	currentBandSize = largestBand
	#start
	$Music.play()
	$GameTimer.start()
	gameRunning = true
	
func increment_time_alive():
	timeAlive += 1

func _on_music_finished():
	$Music.play()
