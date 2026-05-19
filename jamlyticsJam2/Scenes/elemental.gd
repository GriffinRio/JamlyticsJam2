extends RigidBody2D

@export_enum("Fire", "Water", "Earth", "Air") var element: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match element:
		"Fire":
			$MeshInstance2D.modulate = Color("red")
		"Water":
			$MeshInstance2D.modulate = Color("blue")
		"Earth":
			$MeshInstance2D.modulate = Color("green")
		"Air":
			$MeshInstance2D.modulate = Color("light blue")
		_:
			$MeshInstance2D.modulate = Color("pink")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
