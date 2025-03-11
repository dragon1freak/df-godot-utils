extends Node3D
class_name Footstepper


## If true, the Footstepper node's sounds must be called using the helper functions, but may be placed under any node type.
@export var manual_activation := false

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
@export_group("")

@export_group("Sounds", "sound_")
## Sound played by the Run state for footsteps
@export var sound_footstep : AudioStream = preload("./sounds/footstep.ogg")
## Sound played by the Jump state for jumping
@export var sound_jump : AudioStream = preload("./sounds/jump.ogg")
## Sound played by the Fall state when landing
@export var sound_land : AudioStream = preload("./sounds/land.ogg")
@export_group("")


## Holds the position of the player at the previous frame
var previous_position : Vector3 = Vector3.ZERO
## Holds the velocity of the player at the previous frame
var previous_velocity : Vector3 = Vector3.ZERO
## Holds the is_on_floor() state of the player at the previous frame
var previous_floor_state := true
## The CharacterBody3D parent required for automatic functionality to work
var parent : CharacterBody3D

## The internal audio stream player used to play sounds
@onready var audio_player = AudioStreamPlayer3D.new() if audio_is_3d else AudioStreamPlayer.new()

## Set the distance_travelled to half the footstep_distance
@onready var distance_travelled := footstep_distance / 2.0


func _ready() -> void:
	if manual_activation:
		set_physics_process(false)
	else:
		_check_parent()
	_set_up_audioplayer()


func _check_parent() -> void:
	var new_parent = get_parent_node_3d()
	if new_parent is CharacterBody3D:
		parent = new_parent
	else:
		push_warning("Footstepper is set to automatic and parent is not a CharacterBody3D, instead it is currently parented to " + new_parent.name + " and will be removed.")
		queue_free()


func _set_up_audioplayer() -> void:
	audio_player.bus = audio_bus if AudioServer.get_bus_index(audio_bus) >= 0 else default_audio_bus
	audio_player.volume_db = audio_volume
	audio_player.pitch_scale = audio_base_pitch
	add_child(audio_player)


func _physics_process(delta: float) -> void:
	_handle_landing()
	_handle_jumping()
	_handle_footsteps()
	
	previous_floor_state = parent.is_on_floor()
	previous_position = self.global_position
	previous_velocity = parent.velocity


func _handle_footsteps() -> void:
	if previous_floor_state:
		if parent.velocity:
			# Play footstep sound if the player travels the footstep_distance
			if distance_travelled >= footstep_distance:
				distance_travelled = 0.0
				_play_sound(self.sound_footstep)
			else:
				distance_travelled += self.global_position.distance_to(previous_position)
			
		elif distance_travelled < footstep_distance / 2.0:
			distance_travelled = footstep_distance / 2.0


func _handle_jumping() -> void:
	var current_floor_state = parent.is_on_floor()
	
	# Should cover normal jumping and edge cases like coyote time and double jumping
	if (current_floor_state != previous_floor_state and !current_floor_state and previous_floor_state and parent.velocity.y > 0) or (parent.velocity.y > 0 and parent.velocity.y > previous_velocity.y):
		_play_sound(self.sound_jump)


func _handle_landing() -> void:
	var current_floor_state = parent.is_on_floor()
	
	if current_floor_state != previous_floor_state and current_floor_state and !previous_floor_state:
		_play_sound(self.sound_land)
		distance_travelled = 0.0


func _play_sound(sound : AudioStream) -> void:
	audio_player.stream = sound
	audio_player.pitch_scale = randf_range(audio_base_pitch - audio_pitch_variation, audio_base_pitch + audio_pitch_variation)
	audio_player.play()



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
