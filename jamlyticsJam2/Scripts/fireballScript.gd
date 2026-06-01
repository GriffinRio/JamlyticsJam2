extends Area2D
# Constants
const SPEED = 200
# Variables
var direction = Vector2(0,0) # Set by player.gd when fireball spawned

func _ready() -> void:
	look_at(direction)

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Burnable")):
		body.queue_free()
	queue_free()
