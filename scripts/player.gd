extends CharacterBody2D


@export var speed = 100

# Inventory specific
@export var inv_resource: Inv 
var active_slot: int
var playing_animation: bool = false

signal active_slot_changed(new_slot_number: int)
signal slot_changed(slot_number: int)


func _ready() -> void:
	inv_resource.slot_changed.connect(slot_changed.emit)


func _physics_process(delta: float) -> void:
	# Get the input direction vector
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	# Flip the sprite
	if input_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif input_direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	
	if input_direction.x > 0 or input_direction.x < 0:
		$AnimatedSprite2D.play("move_right")
	elif input_direction.y > 0:
		$AnimatedSprite2D.play("move_down")
	elif input_direction.y < 0:
		$AnimatedSprite2D.play("move_up")
	else:
		$AnimatedSprite2D.stop()
	
	# Apply movement
	velocity = input_direction * speed
	move_and_slide()


func set_active_slot(slot_number: int):
	active_slot = slot_number
	active_slot_changed.emit(slot_number)


func get_active_slot(slot_number: int) -> InvSlot:
	return inv_resource.slots[slot_number]
