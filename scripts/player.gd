extends CharacterBody2D


@export var speed = 100

# Inventory specific
@export var inv_resource: Inv 
var active_slot: int
var playing_animation: bool = false

signal active_slot_changed(new_slot_number: int, active_item: InvItem)
signal slot_changed(slot_number: int)


func _ready() -> void:
	inv_resource.slot_changed.connect(slot_changed.emit)
	set_active_slot(0)


func _physics_process(delta: float) -> void:
	# Get the input direction vector
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	# Set animations
	if input_direction.x > 0 or input_direction.x < 0:
		# Flip the sprite
		if input_direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		elif input_direction.x < 0:
			$AnimatedSprite2D.flip_h = true
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


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("slot_1"):
		set_active_slot(0)
	elif event.is_action_pressed("slot_2"):
		set_active_slot(1)
	elif event.is_action_pressed("slot_3"):
		set_active_slot(2)
	elif event.is_action_pressed("slot_4"):
		set_active_slot(3)
	elif event.is_action_pressed("slot_5"):
		set_active_slot(4)
	elif event.is_action_pressed("slot_6"):
		set_active_slot(5)
	elif event.is_action_pressed("slot_7"):
		set_active_slot(6)
	elif event.is_action_pressed("slot_8"):
		set_active_slot(7)
	elif event.is_action_pressed("slot_9"):
		set_active_slot(8)
	elif event.is_action_pressed("slot_10"):
		set_active_slot(9)


func set_active_slot(slot_number: int):
	active_slot = slot_number
	active_slot_changed.emit(slot_number, get_slot(slot_number).item)


func get_slot(slot_number: int) -> InvSlot:
	return inv_resource.slots[slot_number]
