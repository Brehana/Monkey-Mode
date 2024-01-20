extends steering_agent

class_name monkey

enum states{IDLE, MOVING, ATTACKING}

@export var FORCE: float
@export var DAMAGE: float
var _current_state : states

@onready var _audio_stream := $oough

var _target
@onready var _attackReady := true

func _ready():
	_target = GlobalMonkeyTarget.player
	_audio_stream.pitch_scale += randf_range(-.1,.1)
	set_MOVING()

func _physics_process(_delta):
	if(linear_velocity.is_zero_approx() == true && $Footsteps.playing == true):
		$Footsteps.stop()
	if(linear_velocity.is_zero_approx() == false && $Footsteps.playing == false):
		$Footsteps.play()
	if(_target == null):
		if(GlobalMonkeyTarget.player == null):
			set_IDLE()
		else:
			_target = GlobalMonkeyTarget.player
			set_MOVING()
	
	match _current_state:
		states.MOVING:
			arrive_at(_target.position)
			
		states.IDLE:
			pass
		states.ATTACKING:
			arrive_at(_target.position)
			if($Attack_Range.overlaps_body(_target) && _target is enemy && _attackReady == true):
				attack(_target, DAMAGE)
#******************************************************************************
#START - State setters
func set_IDLE():
	_current_state = states.IDLE
	$BaseSprite.modulate = Color(1,1,1,1)
	$AnimationPlayer.play("idle")
	$BaseSprite.play("resting")
func set_MOVING():
	_current_state = states.MOVING
	$BaseSprite.modulate = Color(1,1,1,1)
	$AnimationPlayer.play("walk", 1, randf_range(1,3))
	$BaseSprite.play("active")
func set_ATTACKING():
	_current_state = states.ATTACKING
	$BaseSprite.play("angry")
#END - State setters
#******************************************************************************

func receive_damage(damage, _attacker):
	var animation_player := $AnimationPlayer
	_health -= damage
	if(_health <= 0):
		destroy()
	#Behaviour Code [Injured]
	var current_animation = animation_player.get("current_animation")
	animation_player.play("damage received", 1, 3)
	await animation_player.animation_finished
	animation_player.play(current_animation)

func attack(target : destructable, damage : float):
	target.receive_damage(damage, self)
	$Hitsounds.play()
	_attackReady = false
	$Attack_Cooldown.start()

func range_attack(direction, force):
	var spawnLocation  = Vector2.UP * 20
	var scene = load("res://src/monkey_projectile.tscn")
	var instance = scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = spawnLocation
	instance.apply_central_impulse(direction.normalized() * force)
	_attackReady = false
	$Attack_Cooldown.start(1)
	
func _on_attack_range_body_entered(body):
	if(body is enemy):
		target_enemy(body)
func _on_attack_cooldown_timeout():
	_attackReady = true
func target_enemy(theEnemy):
	_target = theEnemy
	set_ATTACKING()
func _on_oough_cooldown_timeout():
	if(_current_state == states.MOVING):
		_audio_stream.play()
		$Oough_Cooldown.start(randi_range(3, 15))
func _on_tree_entered():
	if(MainGame.largestBand != null):
		MainGame.currentBandSize += 1
		if(MainGame.currentBandSize > MainGame.largestBand):
			MainGame.largestBand = MainGame.currentBandSize
func _on_tree_exited():
	MainGame.currentBandSize -= 1



func _on_footstep_timer_timeout():
	if(linear_velocity.is_zero_approx() == false):
		$Footsteps.pitch_scale = randf_range(0.0, 1.2)
		$Footsteps.play()
		$Footstep_Timer.start(randf_range(1.0,3.0))
