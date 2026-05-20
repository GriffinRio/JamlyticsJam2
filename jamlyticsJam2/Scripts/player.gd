extends CharacterBody2D

const SPEED = 70.0
const JUMP_VELOCITY = -400.0
var stomach = {
	"Fire": 0,
	"Water": 0,
	"Earth": 0,
}
func _ready() -> void:
	$Pivot/AnimatedSprite2D.animation = "idle"
	$Pivot/AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("Jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if(!$Pivot/AnimatedSprite2D.animation == "chomp"):
		print($Pivot/AnimatedSprite2D.animation)
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			$Pivot/AnimatedSprite2D.animation = "walk"
			velocity.x = direction * SPEED
			
		else:
			$Pivot/AnimatedSprite2D.animation = "idle"
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if(direction < 0):
			$Pivot.scale.x = -1 
		elif(direction > 0):
			$Pivot.scale.x = 1
	
		move_and_slide()
	
func _on_mouth_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Elementals")):
		$Pivot/AnimatedSprite2D.animation = "chomp"
		await $Pivot/AnimatedSprite2D.animation_finished
		$Pivot/AnimatedSprite2D.animation = "idle"
		$Pivot/AnimatedSprite2D.play()
		stomach[body.element] += 1
		body.queue_free()
		
