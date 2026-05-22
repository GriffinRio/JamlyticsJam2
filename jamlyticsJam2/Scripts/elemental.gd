extends RigidBody2D

@export_enum("Fire", "Water", "Earth") var element: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (element == ""):
			print("ERROR: No type chosen")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
