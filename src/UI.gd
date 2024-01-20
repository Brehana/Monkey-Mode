extends CanvasLayer

signal game_started

func _ready():
	$HomeWindow.set_visible(true)
	$TutorialWindow.set_visible(false)
	
func _on_play_button_pressed():
	$HomeWindow.set_visible(false)
	$WoodPlanks.set_visible(true)
	$TutorialWindow.set_visible(true)
	
func _on_start_button_pressed():
	game_started.emit()
	set_visible(false)
	MainGame.start()
	
func _on_start_over_pressed():
	MainGame.get_node("Music").stop()
	get_tree().reload_current_scene()

func show_game_over_screen():
	set_visible(true)
	$GameOverWindow/TimeSurvived_label/TimeSurvived.text = str(MainGame.timeAlive)
	$GameOverWindow/TimeSurvived_label/LargestBand.text = str(MainGame.largestBand)
	$GameOverWindow/TimeSurvived_label/SuitsMauled.text = str(MainGame.totalKills)
	$HomeWindow.set_visible(false)
	$TutorialWindow.set_visible(false)
	$WoodPlanks.set_visible(false)
	$GameOverWindow.set_visible(true)
	
