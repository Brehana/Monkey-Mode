extends Control

# Drag variables
var dragging := false
var drag_start := Vector2.ZERO
var current_vector := Vector2.ZERO
@export var max_drag_distance := 80.0  # Max distance in pixels to allow full force
@export var drag_sensitivity := 5.0
@export var joystick_radius := 40.0

# Drawing colors
@export var base_color := Color(0.4, 0.4, 0.4, 0.5)
@export var handle_color := Color(1.0, 1.0, 1.0, 0.8)

# Called when node is added to the scene
func _ready():
	set_process_input(true)
	mouse_filter = Control.MOUSE_FILTER_STOP  # Ensure it catches input

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			dragging = true
			drag_start = event.position
		else:
			dragging = false
			current_vector = Vector2.ZERO
	elif event is InputEventScreenDrag or event is InputEventMouseMotion:
		if dragging:
			var raw_vector = event.position - drag_start
			var normalized_vector = raw_vector.normalized()
			
			current_vector = normalized_vector * clampf(raw_vector.length(), 0, max_drag_distance) * drag_sensitivity
	queue_redraw()

func _physics_process(delta):
	if dragging and GlobalMonkeyTarget.player:
		GlobalMonkeyTarget.player.apply_central_force(current_vector)

func _draw():
	if not dragging:
		return

	# Visualize joystick base
	draw_circle(drag_start, joystick_radius, base_color)

	# Draw handle
	var drag_vector := current_vector / drag_sensitivity
	var handle_pos := drag_start + drag_vector.clampf(-joystick_radius, joystick_radius)
	draw_circle(handle_pos, joystick_radius * 0.5, handle_color)
