extends Node3D
class_name Footstepper


static var COLLIDER_SOUND_CACHE : Dictionary = {}


## If true, the Footstepper node's sounds must be called using the helper functions, but may be placed under any node type.
@export var manual_activation := false

## If true, the Footstepper node will check the material or FootstepperTag name against its sound profiles and play the correct sound
@export var material_aware := false

@export_flags_3d_physics var material_aware_collision_mask = 1

## Distance the player should move between footsteps.
@export var footstep_distance : float = 2.0

## The name of the target audio bus.  If it doesnt exist, will fall back to Master.
@export var audio_bus : String = "Master"
var default_audio_bus : String = "Master"

@export_group("Audio Settings", "audio_")
## If true, the internal audio player will be an AudioStreamPlayer3D. Useful when placed on NPCs and other non client entities.
@export var audio_is_3d := false
## Volume DB of the Footstepper AudioStreamPlayer.
@export_range(-80.0, 24.0) var audio_volume := 0.0
## Base Pitch Scale of the Footstepper AudioStreamPlayer.
@export_range(0.01, 4.0) var audio_base_pitch := 1.0
## How much the pitch should be randomized between plays. Set to 0 to disable the random variation.
@export_range(0.0, 1.0, 0.01) var audio_pitch_variation := 0.1

@export_range(3, 12) var number_of_players := 3
@export_group("")

## The default sound set to play when not using material aware mode. If no default is set, the first sound set with either no
## material name or the material name "default" will be used instead
@export var default_sound_profile : FootstepperSoundProfile
## The other sound profiles used by this Footstepper node, primarily used with material_aware for material based sounds
@export var sound_profiles : Array[FootstepperSoundProfile] = []
## The current sound profile used when playing sounds
var current_sound_profile : FootstepperSoundProfile

var current_collider_id

var material_collider_raycast : RayCast3D

## Holds the position of the player at the previous frame
var previous_position : Vector3 = Vector3.ZERO
## Holds the velocity of the player at the previous frame
var previous_velocity : Vector3 = Vector3.ZERO
## Holds the is_on_floor() state of the player at the previous frame
var previous_floor_state := true
## The CharacterBody3D parent required for automatic functionality to work
var parent : CharacterBody3D

## Array of available audio players
var available_players : Array[AudioStreamPlayer] = []

## Set the distance_travelled to half the footstep_distance
@onready var distance_travelled := footstep_distance / 2.0
@onready var file_name_regex : RegEx = RegEx.create_from_string(".+/([\\w_\\d]+)(?:$|.\\w+)")

func _ready() -> void:
	if manual_activation:
		set_physics_process(false)
	else:
		_check_parent()
	_set_up_audioplayers()
	
	if not default_sound_profile:
		if sound_profiles.size() > 0:
			var new_default_index = sound_profiles.find_custom(func(value: FootstepperSoundProfile):
				return value.material_name == "" or value.material_name.to_lower() == "default"
				)
			if new_default_index >= 0:
				default_sound_profile = sound_profiles[new_default_index]
			else:
				push_error("Footstepper has no default sound set")
		else:
			push_error("Footstepper has no default sound set")
	current_sound_profile = default_sound_profile
	
	if material_aware:
		material_collider_raycast = RayCast3D.new()
		material_collider_raycast.collide_with_bodies = true
		material_collider_raycast.target_position = Vector3.DOWN * 1.25
		material_collider_raycast.add_exception(parent)
		material_collider_raycast.collision_mask = material_aware_collision_mask
		add_child(material_collider_raycast)


func _check_parent() -> void:
	var new_parent = get_parent_node_3d()
	if new_parent is CharacterBody3D:
		parent = new_parent
	else:
		push_warning("Footstepper is set to automatic and parent is not a CharacterBody3D, instead it is currently parented to " + new_parent.name + " and will be removed.")
		queue_free()


func _set_up_audioplayers() -> void:
	var target_bus = audio_bus if AudioServer.get_bus_index(audio_bus) >= 0 else default_audio_bus

	for i in number_of_players:
		var new_audio_player = AudioStreamPlayer3D.new() if audio_is_3d else AudioStreamPlayer.new()
		new_audio_player.bus = target_bus
		new_audio_player.volume_db = audio_volume
		new_audio_player.pitch_scale = audio_base_pitch
		new_audio_player.finished.connect(_on_stream_finished.bind(new_audio_player))
		available_players.push_back(new_audio_player)
		add_child(new_audio_player)


func _physics_process(delta: float) -> void:
	if material_aware:
		_check_material()
	
	_handle_landing()
	_handle_jumping()
	_handle_footsteps()
	
	previous_floor_state = parent.is_on_floor()
	previous_position = self.global_position
	previous_velocity = parent.velocity


func _check_material() -> void:
	var last_collision : Object = material_collider_raycast.get_collider()
	if last_collision and last_collision is Node3D:
		# Check if theres a cached sound first
		var collision_id = last_collision.get_instance_id()
		var existing_sound = COLLIDER_SOUND_CACHE.get(collision_id)
		if existing_sound:
			current_sound_profile = existing_sound
			return
		
		# If not, find the matching sound profile and add it to the cache
		var collider_parent = last_collision.get_parent_node_3d()
		var target_material : Material
		if collider_parent is MeshInstance3D:
			target_material = collider_parent.get_active_material(0)
		elif collider_parent is CSGPrimitive3D:
			target_material = collider_parent.material_override
			if not target_material:
				target_material = collider_parent.material
		elif last_collision is CSGPrimitive3D:
			target_material = last_collision.material_override
			if not target_material:
				target_material = last_collision.material
		else:
			return # TODO: We'll check the tag child here, and if collider itself is CSG
		
		if not target_material:
			return
		
		var target_material_name_res : RegExMatch = file_name_regex.search(target_material.resource_path)
		var target_material_name = target_material_name_res.get_string(1) if target_material_name_res else "default"
		
		var new_sound_profile : FootstepperSoundProfile
		var new_sound_profile_index = sound_profiles.find_custom(func(value : FootstepperSoundProfile):
			return target_material_name.to_lower().contains(value.material_name.to_lower())
			)
		if new_sound_profile_index >= 0:
			new_sound_profile = sound_profiles.get(new_sound_profile_index)
		else:
			new_sound_profile = default_sound_profile
		
		COLLIDER_SOUND_CACHE.set(collision_id, new_sound_profile)
		current_sound_profile = new_sound_profile
		print(target_material_name)


func _handle_footsteps() -> void:
	if previous_floor_state:
		if parent.velocity:
			# Play footstep sound if the player travels the footstep_distance
			if distance_travelled >= footstep_distance:
				distance_travelled = 0.0
				_play_sound(self.current_sound_profile.sound_footstep)
			else:
				distance_travelled += self.global_position.distance_to(previous_position)
		elif distance_travelled < footstep_distance / 2.0:
			distance_travelled = footstep_distance / 2.0


func _handle_jumping() -> void:
	var current_floor_state = parent.is_on_floor()
	
	# Should cover normal jumping and edge cases like coyote time and double jumping
	if (current_floor_state != previous_floor_state and !current_floor_state and previous_floor_state and parent.velocity.y > 0) or (parent.velocity.y > 0 and parent.velocity.y > previous_velocity.y):
		_play_sound(self.current_sound_profile.sound_jump)


func _handle_landing() -> void:
	var current_floor_state = parent.is_on_floor()
	
	if current_floor_state != previous_floor_state and current_floor_state and !previous_floor_state:
		_play_sound(self.current_sound_profile.sound_land)
		distance_travelled = 0.0


func _play_sound(sound : AudioStream) -> void:
	if available_players.size() > 0:
		var audio_player = available_players.pop_back()
		audio_player.stream = sound
		audio_player.pitch_scale = randf_range(audio_base_pitch - audio_pitch_variation, audio_base_pitch + audio_pitch_variation)
		audio_player.play()


func _on_stream_finished(player) -> void:
	available_players.push_back(player)


# Helper functions used for manual activation

## Plays the set footstep sound using the internal AudioStreamPlayer3D
func play_footstep() -> void:
	_play_sound(self.sound_footstep)


## Plays the set landing sound using the internal AudioStreamPlayer3D
func play_landing() -> void:
	_play_sound(self.sound_land)


## Plays the set jump sound using the internal AudioStreamPlayer3D
func play_jump() -> void:
	_play_sound(self.sound_jump)
