@tool
extends EditorPlugin


func _enter_tree() -> void:
	assert(DirAccess.dir_exists_absolute("res://addons/input_helper/"), "Input Helper by Nathan Hoad is a required dependancy of this plugin, make sure it's installed!")
	
	# Dynamic Glyph Nodes
	add_custom_type("DynamicSprite2DGlyph", "Sprite2D", preload("./dynamic_glyph_2d.gd"), preload("./dynamic_sprite2d_glyph.svg"))
	add_custom_type("DynamicSprite3DGlyph", "Sprite3D", preload("./dynamic_glyph_3d.gd"), preload("./dynamic_sprite3d_glyph.svg"))
	add_custom_type("DynamicTextureRectGlyph", "TextureRect", preload("./dynamic_glyph_texture_rect.gd"), preload("./dynamic_texture_rect_glyph.svg"))


func _exit_tree() -> void:
	remove_custom_type("DynamicSprite2DGlyph")
	remove_custom_type("DynamicSprite3DGlyph")
	remove_custom_type("DynamicTextureRectGlyph")
