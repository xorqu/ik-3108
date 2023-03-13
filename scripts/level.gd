extends Spatial

onready var f1 = $QodotMap/entity_0_worldspawn/entity_0_mesh_instance
onready var f2 = $QodotMap/entity_1_func_group/entity_1_mesh_instance
onready var f3 = $QodotMap/entity_2_func_group/entity_2_mesh_instance

onready var sp = $player/sphere/CSGSphere

onready var psx = preload("res://textures/psx.tres")
onready var sph_p = preload("res://textures/sph_p.tres")
onready var sph_d = preload("res://textures/sph_d.tres")
onready var default = preload("res://textures/stone2.tres")

var cursed = false

func _ready():
	pass # Replace with function body.



func _process(delta):
	pass

func _on_crsd_body_entered(body):
	if body.is_in_group('player'):
		f1.set_surface_material(0, psx)
		f2.set_surface_material(0, psx)
		f3.set_surface_material(0, psx)
		sp.set_material(sph_p)
		$ambient.pitch_scale = 0.2
		$soundtrack1.pitch_scale = 0.2
		$player/walk_sound.pitch_scale = 0.6
		$player/walk_sound.volume_db = 5
		cursed = true


func _on_crsd_body_exited(body):
	if body.is_in_group('player'):
		f1.set_surface_material(0, default)
		f2.set_surface_material(0, default)
		f3.set_surface_material(0, default)
		sp.set_material(sph_d)
		$ambient.pitch_scale = 0.5
		$soundtrack1.pitch_scale = 0.38
		$player/walk_sound.pitch_scale = 1
		$player/walk_sound.volume_db = 0
		cursed = false
