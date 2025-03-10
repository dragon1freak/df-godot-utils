# Dragon1Freak's Godot Utils

This collection of addons is intended to speed up projects by providing functionality used across all or many projects such as dynamically showing input device specific glyphs, creating a menu stack to handle menus, etc.
The addons may be original or forks of existing addons (credit and links in their sections) and will vary in complexity.

## General Usage

Drop any of the addon folders above into your project's `addons` folder to use. Depending on the addon, you may need to enable a plugin in your project settings as well.

Supports Godot 4.3 and above, may work on earlier versions of Godot 4 but they aren't tested.

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

<details>
  <summary><h3>Just Another Menu System</h3></summary>

JAMS is an easy way to manage your game's menu states. Currently it supports one open menu at a time which should work for most use cases. The MenuRouter and MenuContainer nodes are extensions of the control node and have no other affect on the layout of your menus allowing you to style them as needed. By calling methods on the MenuRouter node, you can easily open, close, or go to menus with just their name, case insensitive.

The MenuContainer node is also easily extended, so you can implement animations or other functionality on open or close.

---

### Instructions

#### Installation:

Drop the <code>just-another-menu-system</code> folder into your project's <code>addons</code> folder and enable the <code>Just Another Menu System</code> plugin in your project settings.

<br>

#### Usage

JAMS currently comes with two nodes, a `MenuRouter` and a `MenuContainer`

**MenuRouter**

`MenuRouter` is the brain of the system. On `ready`, it finds all existing `MenuContainer` children and registers them in its internal `MENUS` object, closing them unless set to `start_open`. It also holds a history stack of opened menus so you can very easily go back one or more steps no matter how deeply nested your menu is.

| Method                                                                                                       | Description                                                                                                                                                                                               |
| ------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| clear_registered_menus()                                                                                     | Clears all registered menus                                                                                                                                                                               |
| close_all_menus()                                                                                            | Closes all open menus and clears the history stack                                                                                                                                                        |
| close_last_menu(remove_from_stack : bool = false)                                                            | Close the most recent menu. If `remove_from_stack` is true, also removes it from the menu history stack                                                                                                   |
| close_menu(menu_key : String, open_previous_menu : bool = true, on_close_callback : Callable = func(): pass) | Closes the menu registered with the passed key. If `open_previous_menu` is true, the previous menu in the stack is open, if it exists. `on_close_callback` is called after closing the menu, if it exists |
| get_last_menu()                                                                                              | Returns the most recent menu in the stack, if it exists                                                                                                                                                   |
| go_back(open_next : bool = true)                                                                             | Go back one step in the menu history, closing the current menu. If `open_next` is true, opens the previous menu in the stack                                                                              |
| go_to(menu_key : String)                                                                                     | Closes all other menus, clears the menu history, and opens the menu registered with the passed key.                                                                                                       |
| open_menu(menu_key : String, on_open_callback : Callable = func(): pass)                                     | Opens the menu registered with the passed key. `on_open_callback` is called after opening the menu, if it exists                                                                                          |
| register_children()                                                                                          | Finds and registers all MenuContainer child nodes                                                                                                                                                         |
| register_menu(menu_node : MenuContainer, overwrite : bool = true)                                            | Registers the passed MenuContainer with the MenuRouter. If `overwrite` is true, overwrites any previously registered menu of the same name                                                                |

**MenuContainer**

`MenuContainer` is what holds your menus and is controlled by the `MenuRouter`. When being open or closed, the related `on_open()` and `on_close()` methods are called. By default, the visibility is toggled, but you can easily extend the node and override these methods for your own functionality such as triggering animations.

Currently it is **NOT** suggested to nest `MenuContainer` nodes, since only one menu can be open at a time, so the parent menu will be closed, hiding the child menu. You could override the previously mentioned methods and implement this yourself though.

| Method     | Description                 |
| ---------- | --------------------------- |
| on_open()  | Called when the menu opens  |
| on_close() | Called when the menu closes |

</details>

<h3>Bulk Set Materials (old)</h3>

Has been migrated to its own repo as the [Bulk Model Manager](https://github.com/dragon1freak/godot-bulk-model-manager)


