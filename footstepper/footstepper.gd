class_name Footstepper
extends Node3D
## Footstepper is a convenience node for playing footstep, jump, and landing sounds on your characters automatically based
## on their movement. Supports an optional material aware mode for swapping the sound profile per collider material automatically.
## Can also be used manually for use with any non CharacterBody3D node, or if you need to align the sounds with animation frames etc.
## Also supports AudioStreamPlayer3D mode for use with NPCs, third-person characters, or other non-client characters.

## Static cache for collider names, shared between Footstepper nodes for faster collider name lookups
static var COLLIDER_MATERIAL_NAME_CACHE: Dictionary = { }

## If true, the Footstepper node's sounds must be called using the helper functions, but may be placed under any node type.
@export var manual_activation := false
## Distance the player should move between footsteps.
@export var footstep_distance: float = 2.0
## The name of the target audio bus.  If it doesnt exist, will fall back to Master.
@export var audio_bus: String = "Master"
@export_group("Material Aware", "material_aware_")
## If true, the Footstepper node will check the current floor collider's material or FootstepperTag name against its sound profiles and play the correct sound.
@export var material_aware_enabled := false
## The collision mask to used for the Raycast3D when checking colliders for materials and tags.
@export_flags_3d_physics var material_aware_collision_mask = 1
@export_group("")
@export_group("Audio Settings", "audio_")
## If true, the internal audio player will be an AudioStreamPlayer3D. Useful when placed on NPCs, third-person characters, and other non client entities.
@export var audio_is_3d := false
## Volume DB of the Footstepper AudioStreamPlayer.
@export_range(-80.0, 24.0) var audio_volume := 0.0
## Base Pitch Scale of the Footstepper AudioStreamPlayer.
@export_range(0.01, 4.0) var audio_base_pitch := 1.0
## The range at which the pitch will be randomized between plays. Set to 0 to disable the random variation.
@export_range(0.0, 1.0, 0.01) var audio_pitch_variation := 0.1
## Number of AudioStreamPlayer nodes to create and hold. Too few and existing sounds may get cut off to play the next sound,
## too many and itll be redundant. The default of 3 is typically a good number.
@export_range(3, 12) var audio_number_of_players := 3
@export_group("")
## The default sound set to play when not using material aware mode. If no default is set, the first sound set with either no
## material name or the material name "default" will be used instead.
@export var default_sound_profile: FootstepperSoundProfile
## The other sound profiles used by this Footstepper node, primarily used with material_aware for material based sounds but can be used
## to hold alternative profiles that can be set manually, in both automatic and manual mode.
@export var sound_profiles: Array[FootstepperSoundProfile] = []

## Local cache of sound profiles per Footstepper node. This is local as other Footstepper nodes
## may have different profiles for the same material.
var COLLIDER_SOUND_CACHE: Dictionary = { }
## Array of available audio players.
var available_players: Array[AudioStreamPlayer] = []
## ID of the current collider
var current_collider_id
## The current sound profile used when playing sounds.
var current_sound_profile: FootstepperSoundProfile
## Default audio bus to fall back to if the passed bus doesnt exist
var default_audio_bus: String = "Master"
## The RayCast3D used to check the floor colliders and their materials
var material_collider_raycast: RayCast3D
## The CharacterBody3D parent required for automatic functionality to work.
var parent: CharacterBody3D
## Holds the is_on_floor() state of the player at the previous frame.
var previous_floor_state := true
## Holds the position of the player at the previous frame.
var previous_position: Vector3 = Vector3.ZERO
## Holds the velocity of the player at the previous frame.
var previous_velocity: Vector3 = Vector3.ZERO

## Set the distance_travelled to half the footstep_distance
@onready var distance_travelled := footstep_distance / 2.0
## RegEx used to pull the file name from the path with no extension
@onready var file_name_regex: RegEx = RegEx.create_from_string(".+/([\\w_\\d]+)(?:$|.\\w+)")


func _ready() -> void:
	if manual_activation:
		set_physics_process(false)
	else:
		_check_parent()
	_set_up_audioplayers()

	if not default_sound_profile:
		if sound_profiles.size() > 0:
			var new_default_index = sound_profiles.find_custom(
				func(value: FootstepperSoundProfile):
					return value.material_name == "" or value.material_name.to_lower() == "default"
			)
			if new_default_index >= 0:
				default_sound_profile = sound_profiles[new_default_index]
			else:
				push_error("Footstepper has no default sound set")
		else:
			push_error("Footstepper has no default sound set")
	current_sound_profile = default_sound_profile

	if material_aware_enabled:
		material_collider_raycast = RayCast3D.new()
		material_collider_raycast.collide_with_bodies = true
		material_collider_raycast.target_position = Vector3.DOWN * 1.25
		material_collider_raycast.add_exception(parent)
		material_collider_raycast.collision_mask = material_aware_collision_mask
		add_child(material_collider_raycast)


func _physics_process(delta: float) -> void:
	if material_aware_enabled:
		_check_material()

	_handle_landing()
	_handle_jumping()
	_handle_footsteps()

	previous_floor_state = parent.is_on_floor()
	previous_position = self.global_position
	previous_velocity = parent.velocity


# Helper functions used for manual activation
## Plays the set footstep sound using the internal AudioStreamPlayer3D
func play_footstep() -> void:
	_play_sound(self.sound_footstep)


## Plays the set jump sound using the internal AudioStreamPlayer3D
func play_jump() -> void:
	_play_sound(self.sound_jump)


## Plays the set landing sound using the internal AudioStreamPlayer3D
func play_landing() -> void:
	_play_sound(self.sound_land)


## Sets the Footstepper node's current sound profile to the passed profile
func set_sound_profile(new_profile: FootstepperSoundProfile) -> void:
	current_sound_profile = new_profile


## Sets the Footstepper node's current sound profile to the local profile from `sound_profiles` based on the passed index.
func set_sound_profile_index(index: int) -> void:
	set_sound_profile(sound_profiles[index])


func _check_material() -> void:
	var last_collision: Object = material_collider_raycast.get_collider()
	if last_collision and last_collision is Node3D:
		# If the collider is the same as last frame, quit early as theres no change
		var collision_id = last_collision.get_instance_id()
		if collision_id == current_collider_id:
			return

		# Check if theres a cached sound profile
		current_collider_id = collision_id
		var existing_sound = COLLIDER_SOUND_CACHE.get(collision_id)
		if existing_sound:
			current_sound_profile = existing_sound
			return

		# If not, find the matching sound profile and add it to the cache
		var target_material_name = COLLIDER_MATERIAL_NAME_CACHE.get(collision_id)
		if not target_material_name:
			target_material_name = _get_material_name_from_collision(last_collision)
			COLLIDER_MATERIAL_NAME_CACHE.set(collision_id, target_material_name)

		var new_sound_profile: FootstepperSoundProfile
		var new_sound_profile_index = sound_profiles.find_custom(
			func(value: FootstepperSoundProfile):
				return target_material_name.to_lower().contains(value.material_name.to_lower())
		)
		if new_sound_profile_index >= 0:
			new_sound_profile = sound_profiles.get(new_sound_profile_index)
		else:
			new_sound_profile = default_sound_profile

		COLLIDER_SOUND_CACHE.set(collision_id, new_sound_profile)
		current_sound_profile = new_sound_profile


func _check_parent() -> void:
	var new_parent = get_parent_node_3d()
	if new_parent is CharacterBody3D:
		parent = new_parent
	else:
		push_warning("Footstepper is set to automatic and parent is not a CharacterBody3D, instead it is currently parented to " + new_parent.name + " and will be removed.")
		queue_free()


func _get_material_name_from_collision(collision: Node3D) -> String:
	# Check if the collider has a FootstepperTag set first
	var footstepper_tag_array = collision.find_children("*", "FootstepperTag", false)
	if footstepper_tag_array.size() > 0:
		return footstepper_tag_array[0].material_name

	# If not, derive the name from the colliders material, falling back to default if none are found
	var collider_parent = collision.get_parent_node_3d()
	var target_material: Material
	if collider_parent is MeshInstance3D:
		target_material = collider_parent.get_active_material(0)
	elif collider_parent is CSGPrimitive3D:
		target_material = collider_parent.material_override
		if not target_material:
			target_material = collider_parent.material
	elif collision is CSGPrimitive3D:
		target_material = collision.material_override
		if not target_material:
			target_material = collision.material

	if not target_material:
		return "default"

	var target_material_name_res: RegExMatch = file_name_regex.search(target_material.resource_path)
	return target_material_name_res.get_string(1) if target_material_name_res else "default"


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


func _on_stream_finished(player) -> void:
	available_players.push_back(player)


func _play_sound(sound: AudioStream) -> void:
	if available_players.size() > 0:
		var audio_player = available_players.pop_back()
		audio_player.stream = sound
		audio_player.pitch_scale = randf_range(audio_base_pitch - audio_pitch_variation, audio_base_pitch + audio_pitch_variation)
		audio_player.play()


func _set_up_audioplayers() -> void:
	var target_bus = audio_bus if AudioServer.get_bus_index(audio_bus) >= 0 else default_audio_bus

	for i in audio_number_of_players:
		var new_audio_player = AudioStreamPlayer3D.new() if audio_is_3d else AudioStreamPlayer.new()
		new_audio_player.bus = target_bus
		new_audio_player.volume_db = audio_volume
		new_audio_player.pitch_scale = audio_base_pitch
		new_audio_player.finished.connect(_on_stream_finished.bind(new_audio_player))
		available_players.push_back(new_audio_player)
		add_child(new_audio_player)
