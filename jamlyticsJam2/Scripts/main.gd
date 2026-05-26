extends Node2D

@export var levels = []
var current_level_node = null
var current_level = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func switch_level():
	print("Switching")
	if(levels.size() > current_level + 1):
		current_level_node.queue_free()
		var level = levels[current_level + 1].instantiate()
		add_child(level)
		current_level_node = level
		current_level += 1
		var player = current_level_node.get_node("Player")
		player.level_complete.connect(switch_level)
	else:
		print("End")
		

func _on_play_button_button_down() -> void:
	var level = levels[0].instantiate()
	$UI.process_mode = Node.PROCESS_MODE_DISABLED
	$UI.visible = false
	add_child(level)
	current_level_node = level
	current_level = 0
	var player = current_level_node.get_node("Player")
	player.level_complete.connect(switch_level)

func _on_level_select_button_down() -> void:
	print("Level select")
