extends Resource
class_name GlyphConfig


@export_category("Glyphs")
## Texture used when Keyboard and Mouse is the active input
@export var keyboard : Texture
## Texture used when any controller is the active input.  Is also the fallback if a controller specific glyph isnt provided
@export var controller : Texture


## Controller specific overrides, these are used in place of the above controller glyph if provided
@export_group("Specific Controllers")
@export var xbox : Texture
@export var playstation : Texture
@export var steamdeck : Texture
@export var switch : Texture
@export var switch_left_joycon : Texture
@export var switch_right_joycon : Texture


## Returns the glyph related to the passed device name
func get_glyph_by_device(device) -> Texture:
	if device == InputHelper.DEVICE_KEYBOARD:
		return keyboard
	
	match device:
		InputHelper.DEVICE_XBOX_CONTROLLER:
			return xbox if xbox else controller
		InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
			return playstation if playstation else controller
		InputHelper.DEVICE_STEAMDECK_CONTROLLER:
			return steamdeck if steamdeck else controller
		InputHelper.DEVICE_SWITCH_CONTROLLER:
			return switch if switch else controller
		InputHelper.DEVICE_SWITCH_JOYCON_LEFT_CONTROLLER:
			return switch_left_joycon if switch_left_joycon else controller
		InputHelper.DEVICE_SWITCH_JOYCON_RIGHT_CONTROLLER:
			return switch_right_joycon if switch_right_joycon else controller
	
	return controller
