extends CharacterBody2D


@export var speed = 100
@export var inv_resource: PlayerInv
@export var money: int
var moving: bool = false
var game_enabled: bool

enum FaceDirection {DOWN, RIGHT, UP, LEFT}
var face_direction: FaceDirection


func _ready() -> void:
	inv_resource.active_slot = 0
	face_direction = FaceDirection.DOWN


func _physics_process(delta: float) -> void:
	if not game_enabled:
		return
	# Get the input direction vector
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	# Set animations
	if input_direction.x > 0 or input_direction.x < 0:
		# Flip the sprite
		if input_direction.x > 0:
			$AnimatedSprite2D.flip_h = false
			face_direction = FaceDirection.RIGHT
		elif input_direction.x < 0:
			$AnimatedSprite2D.flip_h = true
			face_direction = FaceDirection.LEFT
		$AnimatedSprite2D.play("move_right")
		moving = true
	elif input_direction.y > 0:
		face_direction = FaceDirection.DOWN
		$AnimatedSprite2D.play("move_down")
		moving = true
	elif input_direction.y < 0:
		face_direction = FaceDirection.UP
		$AnimatedSprite2D.play("move_up")
		moving = true
	elif moving:
		$AnimatedSprite2D.stop()
		moving = false
	
	# Apply movement
	velocity = input_direction * speed
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("slot_1"):
		inv_resource.active_slot = 0
	elif event.is_action_pressed("slot_2"):
		inv_resource.active_slot = 1
	elif event.is_action_pressed("slot_3"):
		inv_resource.active_slot = 2
	elif event.is_action_pressed("slot_4"):
		inv_resource.active_slot = 3
	elif event.is_action_pressed("slot_5"):
		inv_resource.active_slot = 4
	elif event.is_action_pressed("slot_6"):
		inv_resource.active_slot = 5
	elif event.is_action_pressed("slot_7"):
		inv_resource.active_slot = 6
	elif event.is_action_pressed("slot_8"):
		inv_resource.active_slot = 7
	elif event.is_action_pressed("slot_9"):
		inv_resource.active_slot = 8
	elif event.is_action_pressed("slot_10"):
		inv_resource.active_slot = 9


func play_work_animation():
	if face_direction == FaceDirection.DOWN:
		$AnimatedSprite2D.play("work_down")
	elif face_direction == FaceDirection.UP:
		$AnimatedSprite2D.play("work_up")
	elif face_direction == FaceDirection.RIGHT:
		$AnimatedSprite2D.play("work_right")
	elif face_direction == FaceDirection.LEFT:
		$AnimatedSprite2D.play("work_right")


func get_slot(slot_number: int) -> InvSlot:
	return inv_resource.slots[slot_number]
