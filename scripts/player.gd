extends CharacterBody2D


@export var speed = 150

# Inventory specific
@export var inv_resource: Inv 
var active_slot: int

signal active_slot_changed(new_slot_number: int)


func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	move_and_slide()


func set_active_slot(slot_number: int):
	active_slot = slot_number
	active_slot_changed.emit(slot_number)


func get_active_slot(slot_number: int) -> InvSlot:
	return inv_resource.slots[slot_number]
