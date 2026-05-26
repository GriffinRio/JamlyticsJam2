extends CharacterBody2D
# Signals
## Emmitted when player starts eating an elemental
signal eating_elemental(elemental)
## Emmitted when player enters exit door of level
signal level_complete
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
var abilities = { # Easy way to link same button to different abilities
	"Fire": fire_ability,
	"Water": water_ability,
	"Earth": earth_ability,
	"Steam": steam_ability,
	"Magma": magma_ability,
	"Mud": mud_ability,
}
var fire_scene = preload("res://Scenes/Abilities/Fireball.tscn")
var earth_scene = preload("res://Scenes/Abilities/rock.tscn")
# Variables
var type = "Neutral"
var movable = true
var stomach = [0, 0, 0] # [Fire, Water, Earth]
var floating = false

# FUNCTIONS ----------------------------------------------------------------------
func _ready() -> void:
	# Starts animator on Nuetral_Idle everytime
	animator.animation = type +  "_Idle"
	animator.play()

func _physics_process(delta: float) -> void:
	# Add the gravity. TODO: Can make own value instead of get_gravity() if want more customization later
	if(floating):
		velocity.y = 2 * -SPEED
	elif(!is_on_floor()):
		velocity += get_gravity() * delta
	# Handles movement IF player currently not doing something else
	if(movable):
		# Gets direction from player (if any) and calculates x velocity while playing correct animation  
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
	else:
		velocity.x = 0

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
	# Steam "ability" happens immediately, not on button press
	if(type == "Steam"):
		abilities[type].call()

func _on_mouth_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Elementals")):
		# Stops movement of player AND elemental being eaten
		movable = false
		eating_elemental.emit(body)
		# Chooses correct chomp animation and waits till it's done
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
		movable = true
		body.queue_free()

func _on_mouth_area_entered(area: Area2D) -> void:
	# Detects exit. Kinda weird to be here, but works for now
	if(area.name == "Exit"):
		level_complete.emit()
	
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("Ability")):
		# Calls ability based on type if it has an ability
		if(type != "Neutral" && type != "Full" && type != "Steam"):
			abilities[type].call()
		else:
			print("No ability")
	# Used for abilities with user based timing 
	elif(event.is_action_released("Ability")):
		if(type == "Water"):
			abilities[type].call()

# ABILITIES ----------------------------------------------------------------------

## Spawns fireball and sends it in direction player is holding
func fire_ability():
	# Get direction
	var x_direction = Input.get_axis("move_left", "move_right")
	# Y is flipped
	var y_direction = Input.get_axis("Up", "Down")
	# Spawn fireball and set direction
	var fireball = fire_scene.instantiate()
	fireball.direction = Vector2(x_direction, y_direction)
	owner.add_child(fireball)
	# TODO: Test why this doesn't work before when Rock does.
	fireball.position = $Pivot/Mouth.global_position

## Makes player float while holding ability button. Called both when button pushed and released. 
func water_ability():
	floating = !floating
	movable = !movable

## Spawns pushable rock next to player
func earth_ability():
	var rock = earth_scene.instantiate()
	rock.position = global_position + Vector2($Pivot.scale.x * 25, -5)
	owner.add_child(rock)

## Called when player because steam type. Constant floating
func steam_ability():
	floating = true

func magma_ability():
	print("Lava")

func mud_ability():
	print("Quicksand")
