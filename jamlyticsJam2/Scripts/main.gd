extends Node2D
# Constants 
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@export var levels = []
# Variables
var current_level_node = null
var current_level = 0

func _ready() -> void:
	color_rect.color.a = 0.0
	current_level = 0

func _input(event: InputEvent) -> void:
	# TODO: For future pause menu
	if(event.is_action_pressed("Pause")):
		get_tree().quit()
	# Reset level because of mistake
	elif(event.is_action_pressed("Reset")):
		switch_level(current_level, 0.25)

## Connected to player level_complete signal. Decides if there is anymore levels to play
func exit_level():
	if(levels.size() > current_level + 1):
		current_level += 1
		switch_level(current_level, 0.75)
	else:
		await fade(1.0, .5).finished
		current_level_node.queue_free()
		add_child(load("res://Scenes/Levels/End.tscn").instantiate())
		await fade(0.0, .5).finished

## Loads a level based on index in the array. Fade duration allows for custimizable use cases
func switch_level(level_index, fade_duration):
	# Fades out and deletes level node
	await fade(1.0, fade_duration).finished
	if(current_level_node):
		current_level_node.queue_free()
	# Creates new level and updates current level variables
	var level = levels[level_index].instantiate()
	add_child(level)
	current_level_node = level
	# Connects exit signal to main and fades back in
	var player = current_level_node.get_node("Player")
	player.level_complete.connect(exit_level)
	fade(0.0, fade_duration)


## Built from transition tutorial. TODO: LEARN WHAT A TWEEN REALLY IS
func fade(target, duration):
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", target, duration)
	return tween
	
func _on_play_button_button_down() -> void:
	# Disable UI elements
	$UI.process_mode = Node.PROCESS_MODE_DISABLED
	$UI.visible = false
	# Always starts at level 1 (i = 0)
	switch_level(current_level, 0.5)

func _on_level_select_button_down() -> void:
	print("Level select")
