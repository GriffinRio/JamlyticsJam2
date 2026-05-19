extends CharacterBody2D


const SPEED = 135.0
const JUMP_VELOCITY = -400.0
var stomach = {
	"Fire": 0,
	"Water": 0,
	"Earth": 0,
}

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("Jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#Change to flip_h when dealing with sprites, hopefully stops jumping
	if(direction > 0):
		rotation = 0.0
	elif(direction < 0):
		rotation = PI
	
	

	move_and_slide()
	



func _on_mouth_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Elementals")):
		stomach[body.element] += 1
		body.queue_free()
	
	
