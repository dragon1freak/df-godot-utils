# Dragon1Freak's Godot Utils

This collection of addons is intended to speed up projects by providing functionality used across all or many projects such as dynamically showing input device specific glyphs, creating a menu stack to handle menus, etc.
The addons may be original or forks of existing addons (credit and links in their sections) and will vary in complexity.

## General Usage

Drop any of the addon folders above into your project's `addons` folder to use. Depending on the addon, you may need to enable a plugin in your project settings as well.

## Addons

<details>
  <summary><h3>Dynamic Input Glyphs - Shows the configured texture based on the current input device</h3></summary>

**This requires Nathan Hoad's <a href="https://github.com/nathanhoad/godot_input_helper">Input Helper</a> addon, make sure its installed AND enabled**

It adds a parent class, three different nodes, and a GlyphConfig resource.

- **DynamicSprite2DGlyph**
  - Sprite2D that will set its texture based on the current device and passed GlyphConfig
- **DynamicSprite3DGlyph**
  - Sprite3D that will set its texture based on the current device and passed GlyphConfig
- **DynamicTextureRectGlyph**
  - TextureRect that will set its texture based on the current device and passed GlyphConfig
- **GlyphConfig**
  - Resource that stores the device glyphs. Allows for easy reuse between dynamic glyph nodes.

---

### Instructions

#### Installation:

Drop the <code>dynamic-input-glyph</code> folder into your project's <code>addons</code> folder and enable the <code>Dynamic Input Glyphs</code> plugin in your project settings.

<br>

#### Usage

All of the provided DynamicGlyph nodes are used in the same way, just in different cases (TextureRect for canvas, Sprite2D for 2D, Sprite3D for 3D)

- Add your desired DynamicGlyph node
- Set the <code>Auto Change</code> value as needed
- Add the GlyphConfig, configure if needed
- Thats it!

GlyphConfigs are straightforward but here's a short explanation:

- The <code>Keyboard</code> and <code>Controller</code> textures are your defaults. Keyboard will show for keyboard and mouse, and Controller will show for any non-keyboard device that doesn't have an override
- All of the <code>Specific Controller</code> textures will override the <code>Controller</code> texture if provided. Use this for controller specific glyph textures

Beyond that, the base <code>DynamicGlyph</code> script and the node specific scripts can be extended for further functionality as needed.

---

<details>
  <summary><strong>FAQ</strong></summary>

**Q: Why does this require Input Helper?**

A: Because Nathan Hoad has done all the hard work to make managing input devices easy, and I highly recommend using it for remapping inputs and such. So why not leverage it?

**Q: Why use resources for the glyph configurations instead of a single configuration file?**

A: With a single configuration file, you still have to set up the individual glyph nodes to check for the correct action/input, as well as set up the configuration file itself. Using individual resources means you're still setting up the
glyph configurations like you would with a single file, but you can just add these to whatever dynamic glyph node you want with no extra work. You can also easilly copy/paste them between nodes, save them and quick load them, etc. You could
also set up a few default configurations you might use between multiple projects such as reloading or interacting, and move those between projects without affecting existing configurations or worrying about changing the single config file later.

 </details>
</details>
