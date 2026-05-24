extends StaticBody2D

signal pushed
signal released
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_top_body_entered(body: Node2D) -> void:
	if(body.is_in_group("ButtonPressers")):
		pushed.emit()


func _on_top_body_exited(body: Node2D) -> void:
	# Will release button even if other thing holding it down
	if(body.is_in_group("ButtonPressers")):
		released.emit()
