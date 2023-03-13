extends KinematicBody

export var speed = 4
export var accel = 10
export var gravity = 50
export var jump = 0
export var sensitivity = 0.5
export var max_angle = 90
export var min_angle = -80

onready var head = $Camera
onready var walk_sound = $walk_sound
onready var sphere_sound = $sphere_sound
onready var raycast = $Camera/RayCast
onready var sphere = $sphere


var look_rot = Vector3.ZERO
var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO

var is_sphere_collected = false
var in_room = false
var checkpoint


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func restart(checkpoint):
	get_tree().reload_current_scene()

func control(delta):
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("space"):
		velocity.y = jump
	move_dir = Vector3(
		Input.get_axis("a", "d"),
		0,
		Input.get_axis("w", "s")
	).normalized().rotated(Vector3.UP, rotation.y)
	velocity.x = lerp(velocity.x, move_dir.x * speed, accel * delta)
	velocity.z = lerp(velocity.z, move_dir.z * speed, accel * delta)
	velocity = move_and_slide(velocity, Vector3.UP)

func walk_sound():
	if Input.is_action_pressed('w'):
		walk_sound.set_stream_paused(false)
	elif Input.is_action_pressed('s'):
		walk_sound.set_stream_paused(false)
	elif Input.is_action_pressed('a'):
		walk_sound.set_stream_paused(false)
	elif Input.is_action_pressed('d'):
		walk_sound.set_stream_paused(false)
	else:
		walk_sound.set_stream_paused(true)

func sphere_interact():
	if raycast.is_colliding():
		var target  = raycast.get_collider()
		if target.is_in_group("sphere"):
			if in_room:
				get_parent().get_node("E").visible = true
			if Input.is_action_just_pressed("e"):
				target.queue_free()
				self.is_sphere_collected = true
				sphere.visible = true
				sphere.get_child(2).omni_range = 100
				sphere_sound.play()
				sphere_sound.get_node("Timer").start()
				get_parent().get_node("E").visible = false
		else:
			get_parent().get_node("E").visible = false
	else:
		get_parent().get_node("E").visible = false	

###
func _physics_process(delta):
	sphere_interact()
	control(delta)
	walk_sound()
	
	if Input.is_action_just_pressed("click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if self.global_translation.y < -50:
		restart(checkpoint)
	
func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)
		
func _on_Timer_timeout():
	sphere_sound.stop()

func _on_sphere_room_body_entered(body):
	if body.is_in_group('player') and is_sphere_collected == false:
		in_room = true

func _on_sphere_room_body_exited(body):
	if body.is_in_group('player'):
		in_room = false
		
func _on_final_body_entered(body):
	if body.is_in_group('player'):
		get_tree().change_scene("res://scenes/final.tscn")
