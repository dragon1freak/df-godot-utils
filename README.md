# Dragon1Freak's Godot Utils

This collection of addons is intended to speed up projects by providing functionality used across all or many projects such as dynamically showing input device specific glyphs, creating a menu stack to handle menus, etc.
The addons may be original or forks of existing addons (credit and links in their sections) and will vary in complexity.

All the addons in this repo are under the MIT license.

## General Usage

Drop any of the addon folders above into your project's `addons` folder to use. Depending on the addon, you may need to enable a plugin in your project settings as well.

Supports Godot 4.3 and above, may work on earlier versions of Godot 4 but they aren't tested.

## Addons

<h3>Dynamic Input Glyphs</h3>

Easily show the correct input glyph based on the current input device in both 2D and 3D.

**This requires Nathan Hoad's <a href="https://github.com/nathanhoad/godot_input_helper">Input Helper</a> addon, make sure its installed AND enabled**

More info in the [docs](/dynamic-input-glyph/README.md)!

<h3>Just Another Menu System</h3>

JAMS is a simple menu state manager that can be used without any extra code, just wire up your menu buttons signals to the MenuRouter's functions!

More info in the [docs](/just-another-menu-system/README.md)!

<h3>Footstepper</h3>

Automatic footstep, jump, and landing sounds for your `CharacterBody3D`! Can also be used in a manual configuration for more complicated controllers or NPCs. Comes with default sounds from [Kenney](https://kenney.nl/) and other CC0 sources.

More info in the [docs](/footstepper/README.md)!

<h3>Bulk Set Materials (old)</h3>

Has been migrated to its own repo as the [Bulk Model Manager](https://github.com/dragon1freak/godot-bulk-model-manager)
