class_name FootstepperSoundProfile
extends Resource

## Material this sound set belongs to. Leave blank if not using "material aware" or
## to create a default sound set for when the material matches no sound set on the Footstepper node
@export var material_name: String = ""
@export_group("Sounds", "sound_")
## Sound played by the Run state for footsteps
@export var sound_footstep: AudioStream = preload("./sounds/footstep.ogg")
## Sound played by the Jump state for jumping
@export var sound_jump: AudioStream = preload("./sounds/jump.ogg")
## Sound played by the Fall state when landing
@export var sound_land: AudioStream = preload("./sounds/land.ogg")

@export_group("")


## Returns true if the passed material name matches this sound set
func matches_material(name: String) -> bool:
	return name == material_name
