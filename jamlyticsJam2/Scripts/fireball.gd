extends Area2D

const SPEED = 200

var direction = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(direction)
	look_at(direction)
	print(rad_to_deg(rotation))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()
