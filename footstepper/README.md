# Footstepper

Adds a `Footstepper` node that automatically handles sounds for footsteps, jumps, and landings when added to a `CharacterBody3D` node! Can also be used manually by calling the related helper functions on the node for more complicated controllers or NPCs.

## Instructions

### Installation:

Drop the <code>footstepper</code> folder into your project's <code>addons</code> folder and enable the <code>Footstepper</code> plugin in your project settings.

### Usage

Regardless of what mode you use, make sure to create at least a `Default Sound Profile` to be used with your `Footstepper` node.

#### Automatic

Just add a `Footstepper` node as a **direct child** of your `CharacterBody3D` node, thats it! You can use the settings on the node to weak the behavior and sounds as needed.

If the automatic logic doesn't work well with your setup, you may need to use the manual mode outlined below.

#### Manual

Add a `Footstepper` node anywhere you want on your controller, then call the related sound functions as needed in your animations, state machines, etc.

The current manual methods are:

- `play_footstep()`
- `play_jump()`
- `play_landing()`

Each of the above simple plays the related sound using the `Footstepper` node's internal AudioStreamPlayer or AudioStreamPlayer3D, depending on your settings.

> You can use an `AudioStreamRandomizer` for the sounds, so if you want random footstep, jump, or landing sounds easily, use that!

### Audio Settings

The `Footstepper` node has a few helpful audio settings to customize the AudioStreamPlayers it uses, adjust them as needed.
- **Is 3D**: If true, the internal audio player will be an AudioStreamPlayer3D. Useful when placed on NPCs, third-person characters, and other non client entities.
- **Volume**: The volume of the created AudioStreamPlayers
- **Base Pitch**: Base Pitch Scale of the created AudioStreamPlayers
- **Pitch Variation**: The range at which the pitch will be randomized between plays. Set to 0 to disable the random variation.
- **Number of Players**: The number of AudioStreamPlayers created. If too few, currently playing sounds may be cut off to play the next one. If too many, it gets redundant.

### Material Aware Mode

Footstepper also supports a material aware mode that allows you to set material specific sound profiles and swap between them automatically. If a material does not have a matching sound profile, the default sound profile will be used instead. 

The material name for the collider is cached globally in a static Dictionary and is **shared between all `Footstepper` nodes** so that name lookups are faster. Meanwhile, the sound profile related to the collider and its name are cached in a **non-static** Dictionary local to each `Footstepper` node and is only looked up once. This is so different `Footstepper` nodes can have different sound profile sets, while still sharing the chache of the collider materials.

> Make sure to move the `Footstepper` node towards the bottom of your character when using material aware mode. The created RayCast3D is 1.25m down, so the typical 2m character heigh may be work immediately, but if you're having detection issues try moving the node down.

#### Quick Start
1. Enable Material Aware mode under the Material Aware group, and set the collision mask for the RayCast3D used to check colliders and their materials as needed
2. Create the related sound profiles in the `sound_profiles` array, assigning the related material name and sounds
3. Set up your colliders and their materials in one of two ways
	3a. Make sure the material, material override, etc on the mesh has the target material in the name. For example, a "sand" sound profile would match "sand.tres", "sandy_ground.tres", "material_sand_01.tres", etc.
	3b. Add a `FootstepperTag` node as a child of the collider and give it a material name, this will be used in the same way as the material names mentioned in 3a, but has priority over the mesh materials. Use a `FootstepperTag` node to override a colliders material or if the related materials are difficult to trace, such as the collider not being a direct child of the related MeshInstance3D node, or if you want to set up collider areas just for setting sound profiles.

Thats it! Your `Footstepper` node should now be automatically determining what sound profile to use based on the surface below the character.

> You can also set the sound profiles manually when Material Aware mode is disabled with `set_sound_profile` and `set_sound_profile_index` if you want to manage the different sound profiles yourself. You can do this in both Automatic and Manual usage modes.
---
