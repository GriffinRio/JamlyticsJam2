extends CharacterBody2D

const SPEED = 30

@export_enum("Fire", "Water", "Earth") var element: String
@export var path : PathFollow2D
@onready var animator = $Pivot/AnimatedSprite2D

var being_eaten = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (element == ""):
		print("ERROR: No type chosen")
	animator.animation = "Idle"
	animator.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if(!being_eaten && path != null):
		path.progress += SPEED * delta
		var target = Vector2(path.position)
		var direction = position.direction_to(target)
		if direction:
			animator.animation = "Walk"
			velocity = direction * SPEED
		else:
			animator.animation = "Idle"
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if(direction.x < 0):
			$Pivot.scale.x = 1 
		elif(direction.x > 0):
			$Pivot.scale.x = -1
		move_and_slide()

func _on_player_eating_elemental(elemental: Variant) -> void:
	if(self == elemental):
		being_eaten = true
		animator.animation = "Idle"
		
