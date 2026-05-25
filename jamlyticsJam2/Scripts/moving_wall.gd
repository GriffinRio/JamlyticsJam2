extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_button_pushed() -> void:
	$AnimationPlayer.play("Open")


func _on_button_released() -> void:
	$AnimationPlayer.play("Close")
