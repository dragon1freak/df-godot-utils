# Footstepper Changelog

## v2.1.0

- Added example scenes for both first and third person
- Added extra sample sounds to show the material aware mode, sourced from FilmCow and Kenney, more in the README
- Split the manual activation mode into per sound toggles, set all three to manual for the same functionality as v2 and before
- Fixed the helper functions, they were not updated for v2 and were not correctly playing the sounds from the current sound profile

## v2.0.0

- Added FootstepperSoundProfile resource that holds groups of sounds related to a material
- Added FootstepperTag node that accepts a material name string
- Added optional `material_aware` flag to Footstepper
	- If true, a RayCast3D is created using the settings on the Footstepper node to check what collider the character is on. Sound profiles are then determined from that collider's material or FootstepperTag child node and the profiles material names. The profile is then cached for that collider ID for faster lookups later.
