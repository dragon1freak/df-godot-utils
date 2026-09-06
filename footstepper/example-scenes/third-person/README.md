For the third person scene, the Footstepper node has footsteps set to manual, and is playing the
footstep sounds through the animation player by calling the Footstepper's `play_footstep()` function
directly. For an imported animation you may need to adjust your import settings to allow for custom
tracks. The audio setting `is_3d` is also enabled, meaning that the player created by the Footstepper
node is an AudioStreamPlayer3D, so the sound is directional and coming from the player. This can also
be useful when using Footstepper with NPCs for directional audio.

## Credits

The third-person controller used for the example is the CC0 controller by SRCoder. It can be found
on the Godot Asset Store both in the engine and here: https://store.godotengine.org/asset/srcoder/srcoders-thirperson-controller/
