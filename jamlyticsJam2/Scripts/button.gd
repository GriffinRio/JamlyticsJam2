extends StaticBody2D
# Signals
# TODO: Signal setup only works if only 1 button and door
signal pushed
signal released

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_top_body_entered(body: Node2D) -> void:
	# TODO: Will play open animation again if something else enters.
	if(body.is_in_group("ButtonPressers")):
		pushed.emit()

func _on_top_body_exited(body: Node2D) -> void:
	# TODO: Will release button even if other thing holding it down
	if(body.is_in_group("ButtonPressers")):
		released.emit()
