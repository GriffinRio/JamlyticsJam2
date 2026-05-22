extends CharacterBody2D

const SPEED = 70.0
const JUMP_VELOCITY = -400.0

var type = ""
var eating = false
var stomach = {
	"Fire": 0,
	"Water": 0,
	"Earth": 0,
}

func _ready() -> void:
	$Pivot/AnimatedSprite2D.animation = "Idle"
	$Pivot/AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction and handle the movement/deceleration.
	if(!eating):
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			$Pivot/AnimatedSprite2D.animation = type + "Walk"
			velocity.x = direction * SPEED
		else:
			$Pivot/AnimatedSprite2D.animation = type + "Idle"
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if(direction < 0):
			$Pivot.scale.x = -1 
		elif(direction > 0):
			$Pivot.scale.x = 1
	
		move_and_slide()
	
func _on_mouth_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Elementals")):
		eating = true
		if(body.element == "Fire"):
			$Pivot/AnimatedSprite2D.animation = type + "Chomp"
		else:
			$Pivot/AnimatedSprite2D.animation = type + "Big_Chomp"
		await $Pivot/AnimatedSprite2D.animation_finished
		$Pivot/AnimatedSprite2D.animation = type + "Idle"
		$Pivot/AnimatedSprite2D.play()
		eating = false
		stomach[body.element] += 1
		body.queue_free()
		
