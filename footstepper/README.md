# Footstepper

Adds a `Footstepper` node that automatically handles sounds for footsteps, jumps, and landings when added to a `CharacterBody3D` node! Can also be used manually by calling the related helper functions on the node for more complicated controllers or NPCs.

## Instructions

### Installation:

Drop the <code>footstepper</code> folder into your project's <code>addons</code> folder and enable the <code>Footstepper</code> plugin in your project settings.

<br>

### Usage

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

---
