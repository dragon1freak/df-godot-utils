# Dragon1Freak's Godot Utils
This collection of addons is intended to speed up projects by providing functionality used across all or many projects such as dynamically showing input device specific glyphs, creating a menu stack to handle menus, etc.
The addons may be original or forks of existing addons (credit and links in their sections) and will vary in complexity.  

## General Usage
Drop any of the addon folders above into your project's `addons` folder to use.  Depending on the addon, you may need to enable a plugin in your project settings as well.  

## Addons

<details>
  <summary><h3>WInput Helper - Fork of Input Helper with util nodes</h3></summary>

  This is a fork of Nathan Hoad's <a href="https://github.com/nathanhoad/godot_input_helper">Input Helper</a> addon.  All this does is add a simple utility for dynamically showing input glyphs.  

  It adds a parent class, three different nodes, and a GlyphConfig resource.
  - <strong>DynamicGlyph</strong>
    - Parent class for the dynamic glyph nodes, can be extended for custom functionality.  Can automatically or manually check for device changes and will set the glyph according to whats available in the provided GlyphConfig resource.
  - **DynamicSprite2DGlyph**
    - Sprite2D that will set its texture based on the current device and passed GlyphConfig
  - **DynamicSprite3DGlyph**
    - Sprite3D that will set its texture based on the current device and passed GlyphConfig
  - **DynamicTextureRectGlyph**
    - TextureRect that will set its texture based on the current device and passed GlyphConfig
  - **GlyphConfig**
    - Resource that stores the device glyphs.  Allows for easy reuse between dynamic glyph nodes.

<br>

  ### Instructions
  
  #### Installation:
  
  Drop the <code>winput_helper</code> folder into your project's <code>addons</code> folder and enable the <code>WInput Helper</code> plugin in your project settings.
  
<br>

  #### Usage
  
  All of the provided DynamicGlyph nodes are used in the same way, just in different cases (TextureRect for canvas, Sprite2D for 2D, Sprite3D for 3D)
  - Add your desired DynamicGlyph node
  - Set the <code>Auto Change</code> value as needed
  - Add the GlyphConfig
  - Thats it!

  GlyphConfigs are straightforward but here's a short explanation:
  - The <code>Keyboard</code> and <code>Controller</code> textures are your defaults.  Keyboard will show for keyboard and mouse, and Controller will show for any non-keyboard device that doesn't have an override
  - All of the <code>Specific Controller</code> textures will override the <code>Controller</code> texture if provided.  Use this for controller specific glyph textures

  Beyond that, the base <code>DynamicGlyph</code> script and the node specific scripts can be extended for further functionality as needed.

<details>
  <summary><strong>FAQ</strong></summary>
  
  **Q: Why use resources for the glyph configurations instead of a single configuration file?**
  
  A: With a single configuration file, you still have to set up the individual glyph nodes to check for the correct action/input, as well as set up the configuration file itself.  Using individual resources means you're still setting up the 
  glyph configurations like you would with a single file, but you can just add these to whatever dynamic glyph node you want with no extra work.  You can also easilly copy/paste them between nodes, save them and quick load them, etc.  You could
  also set up a few default configurations you might use between multiple projects such as reloading or interacting, and move those between projects without affecting existing configurations or worrying about changing the single config file later.
 </details>
</details>
