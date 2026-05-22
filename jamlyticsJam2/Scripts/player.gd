extends CharacterBody2D

#Connect to elementals in levels to check if they need to stop moving.
signal eating_elemental(elemental)

const SPEED = 70.0
const JUMP_VELOCITY = -400.0
const element_types = {
	[1,0,0]: "Fire",
	[0,1,0]: "Water",
	[0,0,1]: "Earth",
	[1,1,0]: "Steam",
	[1,0,1]: "Magma",
	[0,1,1]: "Mud",
	[1,1,1]: "Full",
}

@onready var animator = $Pivot/AnimatedSprite2D
var type = "Neutral"
var eating = false
var stomach = [0, 0, 0] #[Fire, Water, Earth]

func _ready() -> void:
	#Starts animator on Nuetral_Idle everytime
	animator.animation = type +  "_Idle"
	animator.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction and handle the movement/deceleration.
	if(!eating):
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			animator.animation = type + "_Walk"
			velocity.x = direction * SPEED
		else:
			animator.animation = type + "_Idle"
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if(direction < 0):
			$Pivot.scale.x = -1 
		elif(direction > 0):
			$Pivot.scale.x = 1
		move_and_slide()

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
		eating = true
		eating_elemental.emit(body)
		if(body.element == "Fire"):
			animator.animation = type + "_Chomp"
		else:
			animator.animation = type + "_Big_Chomp"
		await animator.animation_finished
		update_type(body.element)
		animator.animation = type + "_Idle"
		animator.play()
		eating = false
		
		body.queue_free()
		
		
