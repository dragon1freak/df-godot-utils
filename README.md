# Dragon1Freak's Godot Utils
This collection of addons is intended to speed up projects by providing functionality used across all or many projects such as dynamically showing input device specific glyphs, creating a menu stack to handle menus, etc.
The addons may be original or forks of existing addons (credit and links in their sections) and will vary in complexity.  

## General Usage
Drop any of the addon folders above into your project's `addons` folder to use.  Depending on the addon, you may need to enable a plugin in your project settings as well.  

## Addons

### WInput Helper
<details>
  <summary>Details</summary>
  This is a fork of Nathan Hoad's [Input Helper](https://github.com/nathanhoad/godot_input_helper) addon.  All this does is add a simple utility for dynamically showing input glyphs.  

  It adds a parent class, three different nodes, and a GlyphConfig resource.
  - DynamicGlyph
    - Parent class for the dynamic glyph nodes, can be extended for custom functionality.  Can automatically or manually check for device changes and will set the glyph according to whats available in the provided GlyphConfig resource.
  - DynamicSprite2DGlyph
    - Sprite2D that will set its texture based on the current device and passed GlyphConfig
  - DynamicSprite3DGlyph
    - Sprite3D that will set its texture based on the current device and passed GlyphConfig
  - DynamicTextureRectGlyph
    - TextureRect that will set its texture based on the current device and passed GlyphConfig
  - GlyphConfig
    - Resource that stores the device glyphs.  Allows for easy reuse between dynamic glyph nodes.
  
 </details>
