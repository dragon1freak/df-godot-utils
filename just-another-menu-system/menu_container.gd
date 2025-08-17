extends Control
class_name MenuContainer
## Control node that holds a menu.  The menu can be basically anything, the MenuContainer node acts as 
## a managed container allowing the [MenuRouter] to open/close it as needed.

## Emitted when the MenuContainer opens
signal opened
## Emitted when the MenuContainer closes
signal closed

## Should this menu start open when the MenuRouter loads
@export var start_open := false
## Should the menu router open the shared menu backround node
@export var use_shared_background := true
## Set what control should be focused when the MenuContainer is opened, helpful for keyboard/gamepad navigation
@export var focus_target : Control
## How long in milliseconds until the focus_target grabs focus, helpful to prevent accidental interactions when the menu opens
@export var focus_target_delay := 250


## True when the MenuContainer instance is open
var is_open := false


func open() -> void:
	is_open = true
	opened.emit()
	on_open()


func close() -> void:
	is_open = false
	closed.emit()
	on_close()


func on_open() -> void:
	visible = true
	if focus_target:
		get_tree().create_timer(focus_target_delay / 1000.0).timeout.connect(func(): focus_target.grab_focus())


func on_close() -> void:
	visible = false
