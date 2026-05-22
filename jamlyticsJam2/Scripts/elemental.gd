extends CharacterBody2D
# Constants
@export_enum("Fire", "Water", "Earth") var element: String
@export var path : PathFollow2D 
@onready var animator = $Pivot/AnimatedSprite2D
const SPEED = 30
# Variables
var being_eaten = false

func _ready() -> void:
	# Starts animator on Idle everytime
	if (element == ""):
		print("ERROR: No type chosen")
	animator.animation = "Idle"
	animator.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Follows path if there is one AND player not currently eating them
	# Gravity currently doesn't when no path set AND player eating elemental
	if(!being_eaten && path != null):
		# Progress the path forward
		path.progress += SPEED * delta
		# Finds the paths current position and points elemental toward it
		var target = Vector2(path.position)
		var direction = position.direction_to(target)
		if direction:
			animator.animation = "Walk"
			velocity = direction * SPEED
		else:
			animator.animation = "Idle"
			velocity.x = move_toward(velocity.x, 0, SPEED)
		# Flips sprite based on direction
		if(direction.x < 0):
			$Pivot.scale.x = 1 
		elif(direction.x > 0):
			$Pivot.scale.x = -1
		move_and_slide()

## Connects to player in scene so elemental knows when to stop moving
func _on_player_eating_elemental(elemental: Variant) -> void:
	if(self == elemental):
		being_eaten = true
		animator.animation = "Idle"
		
