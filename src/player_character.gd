extends monkey
class_name player_character

func _process(_delta):
	if(MainGame.currentBandSize != null && MainGame.timeAlive != null):
		$In_Game_UI/BandCounter.text = "x" + str(MainGame.currentBandSize)
		$In_Game_UI/TimeCounter.text = str(MainGame.timeAlive)
		$In_Game_UI/EnemyWaveCounter.text = "x" + str(MainGame.WAVE_SIZE - MainGame.totalKills)
	if(linear_velocity.is_zero_approx() && _current_state != states.IDLE):
		set_IDLE()
	if(MainGame.gameRunning == true && MainGame.totalKills >= MainGame.WAVE_SIZE):
		$UI/GameOverWindow/GameOver.text = "You Won!"
		$UI.show_game_over_screen()
		$In_Game_UI.set_visible(false)
		MainGame.gameRunning = false
		MainGame.get_node("Victory").play()
	

func _physics_process(_delta):
	if(Input.is_anything_pressed() == true && _current_state != states.MOVING):
		set_MOVING()
	if(Input.is_action_pressed("right")):
		apply_central_impulse(Vector2.RIGHT * _max_speed)
	if(Input.is_action_pressed("left")):
		apply_central_impulse(Vector2.LEFT * _max_speed)
	if(Input.is_action_pressed("up")):
		apply_central_impulse(Vector2.UP * _max_speed)
	if(Input.is_action_pressed("down")):
		apply_central_impulse(Vector2.DOWN * _max_speed)

func destroy():
	var monkeys = GlobalMonkeyTarget.get_all_monkeys()
	if(monkeys.size() - 1 > 0):
		$Respawn_Timer.start()
		set_physics_process(false)
	else:
		MainGame.gameRunning = false
		$In_Game_UI.set_visible(false)
		if($UI/GameOverWindow.visible == false):
			$UI.show_game_over_screen()
		$BaseSprite.set_visible(false)
		set_process(false)
		set_physics_process(false)
		GlobalMonkeyTarget.player = null
		$Body_Hit_Box.call_deferred("set_disabled", true)
		
		
		

func _on_respawn_timer_timeout():
	_health = 200
	var monkeys = GlobalMonkeyTarget.get_all_monkeys()
	var theMonkey = monkeys.pick_random()
	while(theMonkey == self):
		theMonkey = monkeys.pick_random()
	position = theMonkey.position
	theMonkey.destroy()
	set_physics_process(true)
	

func _on_ui_game_started():
	$In_Game_UI.set_visible(true)
	$Camera2D.position_smoothing_enabled = true
	$Camera2D.drag_horizontal_enabled = true
	$Camera2D.drag_vertical_enabled = true
