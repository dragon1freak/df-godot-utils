extends Resource
class_name GlyphConfig


@export_category("Glyphs")
## Texture used when Keyboard and Mouse is the active input
@export var keyboard : Texture
## Texture used when any controller is the active input, also the fallback if a controller specific glyph isnt provided
@export var controller : Texture

@export_group("Specific Controllers")
@export var xbox : Texture
@export var playstation : Texture
@export var steamdeck : Texture
@export var switch : Texture
@export var switch_left_joycon : Texture
@export var switch_right_joycon : Texture
