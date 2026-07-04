# Footstepper Changelog

## v2.0.0

- Added FootstepperSoundProfile resource that holds groups of sounds related to a material
- Added FootstepperTag node that accepts a material name string
- Added optional `material_aware` flag to Footstepper
	- If true, a RayCast3D is created using the settings on the Footstepper node to check what collider the character is on. Sound profiles are then determined from that collider's material or FootstepperTag child node and the profiles material names. The profile is then cached for that collider ID for faster lookups later.
