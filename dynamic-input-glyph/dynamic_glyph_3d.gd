extends Sprite3D
class_name DynamicSprite3DGlyph


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
	var current_glyph = glyph_config.get_glyph_by_device(device)
	set_glyph(current_glyph)


## Sets the texture to `glyph`.  Can be overridden for other nodes or to extend functionality.
func set_glyph(glyph) -> void:
	self.texture = glyph
