class_name steering_agent extends destructable
	
@export var _max_speed : float
@export var _slowing_distance : float
@export var _stopping_distance_threshold: float

#func _physics_process(_delta):
#	if(MouseController.clicked == true):
#		arrive_at(get_global_mouse_position())
		
func arrive_at(target_global_position):
	## Steering Algorithm for Arrival at target. ##
	var target_offset : Vector2 = abs(target_global_position - position)
	var distance : float = target_offset.length()
	var ramped_speed : float = _max_speed * (distance / _slowing_distance )
	var clipped_speed : float = min(ramped_speed, _max_speed)
	var desired_velocity : Vector2 = (clipped_speed / distance) * target_offset
	#EXCEPTION HANDLING to prevent crowding at target
	if(distance <= _stopping_distance_threshold):
		desired_velocity = desired_velocity * 0
	#EXCEPTION HANDLING END.
	apply_central_impulse(position.direction_to(target_global_position).normalized() * desired_velocity - linear_velocity)
	## END - Steering Algorithm for Arrival at target. ## 
