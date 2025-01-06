extends TextureRect
class_name DynamicTextureRectGlyph


## Automatically change the glyph when the input device changes
@export var auto_change := true
## Resource holding the different glyphs.  These can be shared between dynamic glyph nodes
@export var glyph_config : GlyphConfig


func _ready() -> void:
	if auto_change:
		InputHelper.device_changed.connect(func(device, _i): update_glyph(device))
	update_glyph(InputHelper.device)


## Update the glyph based on the current InputHelper device
func check_for_update() -> void:
	update_glyph(InputHelper.device)


## Update the glyph based on the passed in device name
func update_glyph(device) -> void:
	if device == InputHelper.DEVICE_KEYBOARD:
		return set_glyph(glyph_config.keyboard)
	
	match device:
		InputHelper.DEVICE_XBOX_CONTROLLER:
			return set_glyph(glyph_config.xbox if glyph_config.xbox else glyph_config.controller)
		InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
			return set_glyph(glyph_config.playstation if glyph_config.playstation else glyph_config.controller)
		InputHelper.DEVICE_STEAMDECK_CONTROLLER:
			return set_glyph(glyph_config.steamdeck if glyph_config.steamdeck else glyph_config.controller)
		InputHelper.DEVICE_SWITCH_CONTROLLER:
			return set_glyph(glyph_config.switch if glyph_config.switch else glyph_config.controller)
		InputHelper.DEVICE_SWITCH_JOYCON_LEFT_CONTROLLER:
			return set_glyph(glyph_config.switch_left_joycon if glyph_config.switch_left_joycon else glyph_config.controller)
		InputHelper.DEVICE_SWITCH_JOYCON_RIGHT_CONTROLLER:
			return set_glyph(glyph_config.switch_right_joycon if glyph_config.switch_right_joycon else glyph_config.controller)
	
	return set_glyph(glyph_config.controller)


## Sets the texture to `glyph`.  Can be overridden for other nodes or to extend functionality.
func set_glyph(glyph) -> void:
	self.texture = glyph
