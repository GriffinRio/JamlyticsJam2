extends CharacterBody2D

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

var type = "Neutral"
var eating = false
var stomach = [0, 0, 0] #[Fire, Water, Earth]

func _ready() -> void:
	#Starts animator on Nuetral_Idle everytime
	$Pivot/AnimatedSprite2D.animation = type +  "_Idle"
	$Pivot/AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction and handle the movement/deceleration.
	if(!eating):
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			$Pivot/AnimatedSprite2D.animation = type + "_Walk"
			velocity.x = direction * SPEED
		else:
			$Pivot/AnimatedSprite2D.animation = type + "_Idle"
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
	print(type)
		

func _on_mouth_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Elementals")):
		eating = true
		if(body.element == "Fire"):
			$Pivot/AnimatedSprite2D.animation = type + "_Chomp"
		else:
			$Pivot/AnimatedSprite2D.animation = type + "_Big_Chomp"
		await $Pivot/AnimatedSprite2D.animation_finished
		update_type(body.element)
		$Pivot/AnimatedSprite2D.animation = type + "_Idle"
		$Pivot/AnimatedSprite2D.play()
		eating = false
		
		body.queue_free()
		
		
