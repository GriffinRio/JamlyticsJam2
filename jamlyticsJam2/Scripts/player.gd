extends CharacterBody2D
## Emmitted when player starts eating an elemental
signal eating_elemental(elemental)
# Constants
@onready var animator = $Pivot/AnimatedSprite2D
const SPEED = 70.0
const element_types = { # Easy way to determine type based on what's eaten
	[1,0,0]: "Fire",
	[0,1,0]: "Water",
	[0,0,1]: "Earth",
	[1,1,0]: "Steam",
	[1,0,1]: "Magma",
	[0,1,1]: "Mud",
	[1,1,1]: "Full",
}
# Variables
var type = "Neutral"
var eating = false
var stomach = [0, 0, 0] #[Fire, Water, Earth]

func _ready() -> void:
	# Starts animator on Nuetral_Idle everytime
	animator.animation = type +  "_Idle"
	animator.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handles movement IF player currently not eating a elemental
	# Gravity currently doesn't work while eating
	if(!eating):
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			animator.animation = type + "_Walk"
			velocity.x = direction * SPEED
		else:
			animator.animation = type + "_Idle"
			velocity.x = move_toward(velocity.x, 0, SPEED)
		# Flips sprite based on direction
		if(direction < 0):
			$Pivot.scale.x = -1 
		elif(direction > 0):
			$Pivot.scale.x = 1
		move_and_slide()

## Updates current type of the player based on what was eaten
func update_type(element):
	match element:
		"Fire":
			stomach[0] = 1
		"Water":
			stomach[1] = 1
		"Earth":
			stomach[2] = 1
		_:
			print("Error: Unkown element")
	type = element_types[stomach]

func _on_mouth_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Elementals")):
		# Stops movement of player AND elemental being eaten
		eating = true
		eating_elemental.emit(body)
		# Choosed correct chomp animation and waits till it's done
		if(body.element == "Fire"):
			animator.animation = type + "_Chomp"
		else:
			animator.animation = type + "_Big_Chomp"
		await animator.animation_finished
		# Update type and reset animator
		update_type(body.element)
		animator.animation = type + "_Idle"
		animator.play()
		# Allows player movement and deletes elemental
		eating = false
		body.queue_free()
